package servlets;

import Logica.Administrativo;
import Logica.Controller;
import Logica.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "SvAdministrativos", value = "/SvAdministrativos")
public class SvAdministrativos extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Administrativo> lista = controller.getAdministrativos();
        List<Usuario> usuariosDisponibles = controller.getUsuariosSinAdministrativo();

        HttpSession sesion = request.getSession();
        sesion.setAttribute("listaAdministrativos", lista);
        sesion.setAttribute("usuariosSinAdministrativo", usuariosDisponibles);

        response.sendRedirect("ver-administrativos.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String fechaNacStr = request.getParameter("fecha_nac");
        String sector = request.getParameter("sector");

        Date fechaNac = null;
        try {
            if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                fechaNac = new SimpleDateFormat("yyyy-MM-dd").parse(fechaNacStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        String idUsuarioExistenteStr = request.getParameter("id_usuario_existente");
        int idUsuarioExistente = (idUsuarioExistenteStr != null && !idUsuarioExistenteStr.isEmpty())
                ? Integer.parseInt(idUsuarioExistenteStr) : 0;

        String usuario = request.getParameter("usuario");
        String pass = request.getParameter("pass");
        String rol = request.getParameter("rol");

        if (idUsuarioExistente > 0) {
            controller.crearAdministrativoConUsuarioExistente(dni, nombre, apellido, direccion, telefono, fechaNac, sector, idUsuarioExistente);
        } else if (usuario != null && !usuario.trim().isEmpty() && pass != null && !pass.trim().isEmpty()) {
            controller.crearAdministrativo(dni, nombre, apellido, direccion, telefono, fechaNac, sector, usuario, pass, rol);
        } else {
            // Usuario por defecto si no se completó ni eligió
            controller.crearAdministrativo(dni, nombre, apellido, direccion, telefono, fechaNac, sector, dni, dni, "Administrativo");
        }

        response.sendRedirect("SvAdministrativos");
    }
}
