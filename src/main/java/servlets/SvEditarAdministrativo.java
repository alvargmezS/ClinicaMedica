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

@WebServlet(name = "SvEditarAdministrativo", value = "/SvEditarAdministrativo")
public class SvEditarAdministrativo extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Administrativo admin = controller.getAdministrativo(id);
        List<Usuario> usuariosDisponibles = controller.getUsuariosDisponiblesParaEditarAdministrativo(admin);

        HttpSession sesion = request.getSession();
        sesion.setAttribute("adminEditar", admin);
        sesion.setAttribute("usuariosEditarAdmin", usuariosDisponibles);

        response.sendRedirect("editar-administrativo.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String sector = request.getParameter("sector");
        String fechaNacStr = request.getParameter("fecha_nac");
        int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));

        Date fechaNac = null;
        try {
            if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                fechaNac = new SimpleDateFormat("yyyy-MM-dd").parse(fechaNacStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        controller.editAdministrativo(id, dni, nombre, apellido, direccion, telefono, fechaNac, sector, idUsuario);

        request.getSession().removeAttribute("adminEditar");
        request.getSession().removeAttribute("usuariosEditarAdmin");

        response.sendRedirect("SvAdministrativos");
    }
}
