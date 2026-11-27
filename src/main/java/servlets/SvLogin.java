package servlets;

import java.io.IOException;

import Logica.Controller;
import Logica.LoginAttemptService;
import Logica.SecurityUtils;
import Logica.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SvLogin", value = "/SvLogin")
public class SvLogin extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String pass = request.getParameter("pass");

        if (usuario == null || pass == null || usuario.trim().isEmpty() || pass.trim().isEmpty()) {
            response.sendRedirect("login-error.jsp");
            return;
        }

        usuario = usuario.trim();

        // 1. Control de Tasa / Prevención de Fuerza Bruta
        if (LoginAttemptService.estaBloqueado(usuario)) {
            int minutos = LoginAttemptService.getMinutosRestantesBloqueo(usuario);
            HttpSession session = request.getSession(true);
            session.setAttribute("mensajeErrorLogin", "Acceso bloqueado por reiterados intentos fallidos. Por favor, espera " + minutos + " minuto(s) antes de reintentar.");
            response.sendRedirect("login-error.jsp");
            return;
        }

        // 2. Verificación de credenciales con BCrypt
        Usuario usu = controller.obtenerUsuario(usuario, pass);

        if (usu != null) {
            // Éxito: restablecer intentos fallidos
            LoginAttemptService.registrarExito(usuario);

            // 3. Mitigación de Session Fixation: Regenerar ID de sesión al autenticar
            request.changeSessionId();

            HttpSession sesion = request.getSession(true);
            sesion.setAttribute("usuario", usu.getNombre_usuario());
            sesion.setAttribute("rol", usu.getRol());

            // 4. Generación inicial de Token anti-CSRF para la sesión autenticada
            SecurityUtils.obtenerOGenerarTokenCsrf(sesion);

            response.sendRedirect("ver-citas.jsp");
        } else {
            // Fallo de autenticación: registrar intento
            LoginAttemptService.registrarFallo(usuario);
            HttpSession session = request.getSession(true);
            session.setAttribute("mensajeErrorLogin", "Usuario o contraseña incorrectos.");
            response.sendRedirect("login-error.jsp");
        }
    }
}
