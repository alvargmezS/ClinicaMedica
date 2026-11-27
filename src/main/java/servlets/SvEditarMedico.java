package servlets;

import Logica.Controller;
import Logica.Medico;
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

@WebServlet(name = "SvEditarMedico", value = "/SvEditarMedico")
public class SvEditarMedico extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Medico med = controller.getMedico(id);
        List<Usuario> usuariosDisponibles = controller.getUsuariosDisponiblesParaEditar(med);

        HttpSession sesion = request.getSession();
        sesion.setAttribute("medicoEditar", med);
        sesion.setAttribute("usuariosEditarMedico", usuariosDisponibles);

        response.sendRedirect("editar-medico.jsp");
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
        String especialidad = request.getParameter("especialidad");
        String fechaNacStr = request.getParameter("fecha_nac");

        String horaInicio = request.getParameter("hora_inicio");
        String horaFin = request.getParameter("hora_fin");
        int idUsuario = Integer.parseInt(request.getParameter("id_usuario"));

        Date fechaNac = null;
        try {
            if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                fechaNac = new SimpleDateFormat("yyyy-MM-dd").parse(fechaNacStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        controller.editMedico(id, dni, nombre, apellido, direccion, telefono, fechaNac, especialidad, horaInicio, horaFin, idUsuario);

        request.getSession().removeAttribute("medicoEditar");
        request.getSession().removeAttribute("usuariosEditarMedico");

        response.sendRedirect("SvMedicos");
    }
}
