package filtros;

import Logica.SecurityUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})
public class FiltroAutenticacion implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Inyección de Cabeceras de Seguridad HTTP (OWASP Secure Headers)
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        response.setHeader("X-XSS-Protection", "1; mode=block");
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        String contextPath = request.getContextPath();
        // Normalización canónica de ruta para evitar bypass con matrix parameters o path traversal
        String rutaRelativa = request.getServletPath();
        if (request.getPathInfo() != null) {
            rutaRelativa += request.getPathInfo();
        }

        // 1. Permitir acceso libre a recursos estáticos (CSS, JS, imágenes, fuentes)
        if (esRecursoEstatico(rutaRelativa)) {
            chain.doFilter(req, res);
            return;
        }

        // 2. Permitir acceso libre a páginas de login y logout
        if (esRutaPublica(rutaRelativa)) {
            chain.doFilter(req, res);
            return;
        }

        // 3. Comprobación de autenticación (sesión activa)
        HttpSession session = request.getSession(false);
        String usuario = (session != null) ? (String) session.getAttribute("usuario") : null;
        String rol = (session != null) ? (String) session.getAttribute("rol") : null;

        if (usuario == null) {
            // Usuario no autenticado: redirigir a login
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // Prevención de almacenamiento en caché de datos médicos en el navegador
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Asegurar que la sesión tenga inicializado su token anti-CSRF
        SecurityUtils.obtenerOGenerarTokenCsrf(session);

        // 4. Control de Autorización por Roles (RBAC)

        // A) Gestión de Usuarios: SOLO Admin
        if (esRutaGestionUsuarios(rutaRelativa)) {
            if (!esAdmin(rol)) {
                response.sendRedirect(contextPath + "/sin-permiso.jsp");
                return;
            }
        }

        // B) Alta de Médicos: Admin y Administrativo
        if (rutaRelativa.equals("/alta-medico.jsp") || (rutaRelativa.equals("/SvMedicos") && "POST".equalsIgnoreCase(request.getMethod()))) {
            if (!esAdmin(rol) && !esAdministrativo(rol)) {
                response.sendRedirect(contextPath + "/sin-permiso.jsp");
                return;
            }
        }

        // Edición y Eliminación de Médicos: SOLO Admin
        if (rutaRelativa.equals("/editar-medico.jsp")
                || rutaRelativa.equals("/SvEditarMedico")
                || rutaRelativa.equals("/SvEliminarMedico")) {
            if (!esAdmin(rol)) {
                response.sendRedirect(contextPath + "/sin-permiso.jsp");
                return;
            }
        }

        // C) Gestión de Administrativos (Alta, Edición y Eliminación): SOLO Admin
        if (esRutaGestionAdministrativos(rutaRelativa)) {
            if (!esAdmin(rol)) {
                response.sendRedirect(contextPath + "/sin-permiso.jsp");
                return;
            }
        }

        // D) Ver Médicos: Admin y Administrativo
        if (rutaRelativa.equals("/ver-medicos.jsp") || (rutaRelativa.equals("/SvMedicos") && "GET".equalsIgnoreCase(request.getMethod()))) {
            if (!esAdmin(rol) && !esAdministrativo(rol)) {
                response.sendRedirect(contextPath + "/sin-permiso.jsp");
                return;
            }
        }

        // E) Generar Informes Médicos: Medico y Admin
        if (rutaRelativa.equals("/generar-informe.jsp") || (rutaRelativa.equals("/SvGenerarInforme") && "POST".equalsIgnoreCase(request.getMethod()))) {
            if (!esAdmin(rol) && !esMedico(rol)) {
                response.sendRedirect(contextPath + "/sin-permiso.jsp");
                return;
            }
        }

        // 5. Validación Anti-CSRF en operaciones destructivas de eliminación (POST)
        if (esPeticionEliminacionCritica(rutaRelativa, request.getMethod())) {
            if (!SecurityUtils.validarTokenCsrf(request)) {
                response.sendRedirect(contextPath + "/sin-permiso.jsp");
                return;
            }
        }

        // Si supera todas las restricciones, continúa al recurso solicitado
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }

    private boolean esRecursoEstatico(String ruta) {
        String lower = ruta.toLowerCase();
        return lower.endsWith(".css") || lower.endsWith(".js")
                || lower.endsWith(".png") || lower.endsWith(".jpg")
                || lower.endsWith(".jpeg") || lower.endsWith(".gif")
                || lower.endsWith(".svg") || lower.endsWith(".ico")
                || lower.endsWith(".woff") || lower.endsWith(".woff2")
                || lower.endsWith(".ttf") || lower.endsWith(".map")
                || lower.startsWith("/css/") || lower.startsWith("/js/")
                || lower.startsWith("/img/") || lower.startsWith("/vendor/")
                || lower.startsWith("/scss/");
    }

    private boolean esRutaPublica(String ruta) {
        return ruta.equals("/login.jsp")
                || ruta.equals("/login-error.jsp")
                || ruta.equals("/SvLogin")
                || ruta.equals("/SvLogout")
                || ruta.equals("/error-404.jsp")
                || ruta.equals("/error-500.jsp");
    }

    private boolean esRutaGestionUsuarios(String ruta) {
        return ruta.equals("/alta-usuario.jsp")
                || ruta.equals("/ver-usuarios.jsp")
                || ruta.equals("/editar-usuario.jsp")
                || ruta.equals("/SvUsuario")
                || ruta.equals("/SvEditarUsuario")
                || ruta.equals("/SvEliminarUsuario");
    }

    private boolean esRutaGestionAdministrativos(String ruta) {
        return ruta.equals("/alta-administrativo.jsp")
                || ruta.equals("/ver-administrativos.jsp")
                || ruta.equals("/editar-administrativo.jsp")
                || ruta.equals("/SvAdministrativos")
                || ruta.equals("/SvEditarAdministrativo")
                || ruta.equals("/SvEliminarAdministrativo");
    }

    private boolean esPeticionEliminacionCritica(String ruta, String metodo) {
        if (!"POST".equalsIgnoreCase(metodo)) {
            return false;
        }
        return ruta.equals("/SvEliminarUsuario")
                || ruta.equals("/SvEliminarMedico")
                || ruta.equals("/SvEliminarPaciente")
                || ruta.equals("/SvEliminarCita")
                || ruta.equals("/SvEliminarAdministrativo");
    }

    private boolean esAdmin(String rol) {
        return rol != null && (rol.equalsIgnoreCase("admin") || rol.equalsIgnoreCase("administrador"));
    }

    private boolean esAdministrativo(String rol) {
        return rol != null && (rol.equalsIgnoreCase("administrativo") || rol.equalsIgnoreCase("recepcionista") || rol.equalsIgnoreCase("secretaria"));
    }

    private boolean esMedico(String rol) {
        return rol != null && (rol.equalsIgnoreCase("medico") || rol.equalsIgnoreCase("doctor"));
    }
}
