package servlets;

import Logica.Cita;
import Logica.Controller;
import Logica.Medico;
import Logica.Paciente;
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

@WebServlet(name = "SvCitas", value = "/SvCitas")
public class SvCitas extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Cita> listaCitas = controller.getCitas();
        List<Medico> listaMedicos = controller.getMedicos();
        List<Paciente> listaPacientes = controller.getPacientes();

        HttpSession sesion = request.getSession();
        sesion.setAttribute("listaCitas", listaCitas);
        sesion.setAttribute("listaMedicos", listaMedicos);
        sesion.setAttribute("listaPacientes", listaPacientes);

        response.sendRedirect("ver-citas.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        try {
            int idMedico = Integer.parseInt(request.getParameter("id_medico"));
            String idPacienteStr = request.getParameter("id_paciente");
            int idPaciente;

            // Opción de crear paciente rápido si se seleccionó "nuevo" o no había pacientes
            if ("nuevo".equalsIgnoreCase(idPacienteStr) || idPacienteStr == null || idPacienteStr.isEmpty()) {
                String dniPac = request.getParameter("pac_dni");
                String nombrePac = request.getParameter("pac_nombre");
                String apellidoPac = request.getParameter("pac_apellido");
                String telPac = request.getParameter("pac_telefono");

                if (dniPac == null || dniPac.trim().isEmpty() || nombrePac == null || nombrePac.trim().isEmpty()) {
                    throw new IllegalArgumentException("Debes seleccionar un paciente existente o ingresar los datos del nuevo paciente (Nombre y DNI).");
                }

                Paciente nuevoPac = controller.crearPaciente(dniPac, nombrePac, apellidoPac, telPac, "", new Date(), "Particular", "Sin especificar");
                idPaciente = nuevoPac.getId_persona();
            } else {
                idPaciente = Integer.parseInt(idPacienteStr);
            }

            String fechaStr = request.getParameter("fecha_cita");
            String horaCita = request.getParameter("hora_cita");
            String motivo = request.getParameter("motivo");

            if (fechaStr == null || fechaStr.isEmpty() || horaCita == null || horaCita.isEmpty()) {
                throw new IllegalArgumentException("Debes indicar la fecha y hora de la cita.");
            }

            Date fechaCita;
            try {
                fechaCita = new SimpleDateFormat("yyyy-MM-dd").parse(fechaStr);
            } catch (ParseException e) {
                throw new IllegalArgumentException("Formato de fecha inválido.");
            }

            // Llamada al controlador lógico con validación estricta de horario
            controller.crearCita(idMedico, idPaciente, fechaCita, horaCita, motivo);

            sesion.setAttribute("mensajeExito", "Cita agendada correctamente para el médico seleccionado.");
            response.sendRedirect("SvCitas");

        } catch (IllegalArgumentException ex) {
            sesion.setAttribute("errorCita", ex.getMessage());
            response.sendRedirect("alta-cita.jsp");
        } catch (Exception ex) {
            sesion.setAttribute("errorCita", "Error inesperado al agendar la cita: " + ex.getMessage());
            response.sendRedirect("alta-cita.jsp");
        }
    }
}
