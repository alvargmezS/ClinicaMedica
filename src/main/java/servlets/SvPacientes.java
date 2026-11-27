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
import java.util.List;

@WebServlet(name = "SvPacientes", value = "/SvPacientes")
public class SvPacientes extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Paciente> listaPacientes = controller.getPacientes();

        HttpSession sesion = request.getSession();
        sesion.setAttribute("listaPacientes", listaPacientes);

        response.sendRedirect("ver-pacientes.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        String dni = request.getParameter("dni");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
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

        // Datos del responsable (para menores de edad o a petición)
        String respDni = request.getParameter("resp_dni");
        String respNombre = request.getParameter("resp_nombre");
        String respApellido = request.getParameter("resp_apellido");
        String respTelefono = request.getParameter("resp_telefono");
        String respDireccion = request.getParameter("resp_direccion");
        String respTipo = request.getParameter("resp_tipo");

        Responsable responsable = null;
        if (respNombre != null && !respNombre.trim().isEmpty() && respDni != null && !respDni.trim().isEmpty()) {
            responsable = new Responsable();
            responsable.setDni(respDni.trim());
            responsable.setNombre(respNombre.trim());
            responsable.setApellido(respApellido != null ? respApellido.trim() : "");
            responsable.setTelefono(respTelefono != null ? respTelefono.trim() : "");
            responsable.setDireccion(respDireccion != null ? respDireccion.trim() : "");
            responsable.setTipo_responsable(respTipo != null && !respTipo.trim().isEmpty() ? respTipo.trim() : "Padre/Madre/Tutor");
        }

        controller.crearPacienteConResponsable(dni, nombre, apellido, telefono, direccion, fechaNac, seguro, grupoSangre, responsable);

        sesion.setAttribute("mensajeExito", "Paciente registrado exitosamente" + (responsable != null ? " con tutor legal/responsable asociado." : "."));
        response.sendRedirect("SvPacientes");
    }
}
