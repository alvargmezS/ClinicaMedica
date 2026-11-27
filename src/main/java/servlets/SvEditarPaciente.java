package servlets;

import Logica.Controller;
import Logica.Paciente;
import Logica.Responsable;
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

@WebServlet(name = "SvEditarPaciente", value = "/SvEditarPaciente")
public class SvEditarPaciente extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("SvPacientes");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Paciente pac = controller.getPaciente(id);
            if (pac == null) {
                response.sendRedirect("SvPacientes");
                return;
            }

            HttpSession sesion = request.getSession();
            sesion.setAttribute("pacienteEditar", pac);

            response.sendRedirect("editar-paciente.jsp");
        } catch (NumberFormatException e) {
            response.sendRedirect("SvPacientes");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String dni = request.getParameter("dni");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String fechaNacStr = request.getParameter("fecha_nac");
            String seguro = request.getParameter("seguro_medico");
            String grupoSangre = request.getParameter("grupo_sangre");

            Date fechaNac = null;
            try {
                if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                    fechaNac = new SimpleDateFormat("yyyy-MM-dd").parse(fechaNacStr);
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }

            // Datos del Responsable / Tutor
            String respNombre = request.getParameter("resp_nombre");
            String respApellido = request.getParameter("resp_apellido");
            String respDni = request.getParameter("resp_dni");
            String respTelefono = request.getParameter("resp_telefono");
            String respDireccion = request.getParameter("resp_direccion");
            String respTipo = request.getParameter("resp_tipo");

            Responsable resp = null;
            if (respNombre != null && !respNombre.trim().isEmpty()) {
                resp = new Responsable();
                resp.setNombre(respNombre.trim());
                resp.setApellido(respApellido != null ? respApellido.trim() : "");
                resp.setDni(respDni != null ? respDni.trim() : "");
                resp.setTelefono(respTelefono != null ? respTelefono.trim() : "");
                resp.setDireccion(respDireccion != null ? respDireccion.trim() : "");
                resp.setTipo_responsable(respTipo != null && !respTipo.trim().isEmpty() ? respTipo.trim() : "Padre/Madre/Tutor");
            }

            controller.editPaciente(id, dni, nombre, apellido, telefono, direccion, fechaNac, seguro, grupoSangre, resp);

            sesion.removeAttribute("pacienteEditar");
            sesion.setAttribute("mensajeExito", "Paciente actualizado exitosamente.");
            response.sendRedirect("SvPacientes");

        } catch (Exception e) {
            sesion.setAttribute("mensajeError", "Error al actualizar paciente: " + e.getMessage());
            response.sendRedirect("SvPacientes");
        }
    }
}
