package servlets;

import Logica.AuditService;
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
import java.util.Date;
import java.util.List;

@WebServlet(name = "SvGenerarInforme", value = "/SvGenerarInforme")
public class SvGenerarInforme extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int idPaciente = Integer.parseInt(idStr);
                Paciente paciente = controller.getPaciente(idPaciente);
                request.setAttribute("pacienteSeleccionado", paciente);
            } catch (NumberFormatException ignored) {}
        }

        List<Paciente> listaPacientes = controller.getPacientes();
        List<Medico> listaMedicos = controller.getMedicos();

        HttpSession session = request.getSession();
        String usuarioLogueado = (String) session.getAttribute("usuario");
        Medico medicoSesion = controller.getMedicoPorUsuario(usuarioLogueado);

        request.setAttribute("listaPacientes", listaPacientes);
        request.setAttribute("listaMedicos", listaMedicos);
        request.setAttribute("medicoSesion", medicoSesion);

        request.getRequestDispatcher("generar-informe.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idPacienteStr = request.getParameter("id_paciente");
        String idMedicoStr = request.getParameter("id_medico");
        String motivo = request.getParameter("motivo");
        String diagnostico = request.getParameter("diagnostico");
        String tratamiento = request.getParameter("tratamiento");
        String observaciones = request.getParameter("observaciones");

        if (idPacienteStr == null || idPacienteStr.trim().isEmpty()) {
            response.sendRedirect("SvPacientes");
            return;
        }

        int idPaciente = Integer.parseInt(idPacienteStr);
        int idMedico = 0;

        if (idMedicoStr != null && !idMedicoStr.trim().isEmpty()) {
            try {
                idMedico = Integer.parseInt(idMedicoStr);
            } catch (NumberFormatException ignored) {}
        }

        HttpSession session = request.getSession();
        String usuarioLogueado = (String) session.getAttribute("usuario");
        String rolLogueado = (String) session.getAttribute("rol");

        // Si no se envió id_medico explícito (por ejemplo, perfil de Médico donde está fijo),
        // intentar asociar con el médico logueado
        if (idMedico <= 0) {
            Medico med = controller.getMedicoPorUsuario(usuarioLogueado);
            if (med != null) {
                idMedico = med.getId_persona();
            }
        }

        try {
            controller.crearInformeMedico(idPaciente, idMedico, motivo, diagnostico, tratamiento, observaciones, new Date());
            
            // Auditoría de registro de informe facultativo
            AuditService.registrarCreacionInforme(usuarioLogueado, rolLogueado, idPaciente, idMedico, request.getRemoteAddr());

            response.sendRedirect("SvHistorialPaciente?id=" + idPaciente);
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorInforme", e.getMessage());
            response.sendRedirect("SvHistorialPaciente?id=" + idPaciente);
        }
    }
}
