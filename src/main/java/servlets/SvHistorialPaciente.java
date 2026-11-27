package servlets;

import Logica.AuditService;
import Logica.Cita;
import Logica.Controller;
import Logica.InformeMedico;
import Logica.Medico;
import Logica.Paciente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SvHistorialPaciente", value = "/SvHistorialPaciente")
public class SvHistorialPaciente extends HttpServlet {

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
            int idPaciente = Integer.parseInt(idStr);
            Paciente paciente = controller.getPaciente(idPaciente);

            if (paciente == null) {
                response.sendRedirect("SvPacientes");
                return;
            }

            List<InformeMedico> informes = controller.getInformesPorPaciente(idPaciente);
            List<Cita> citas = controller.getCitasPorPaciente(idPaciente);
            List<Medico> medicos = controller.getMedicos();

            HttpSession session = request.getSession();
            String usuarioLogueado = (String) session.getAttribute("usuario");
            String rolLogueado = (String) session.getAttribute("rol");
            Medico medicoSesion = controller.getMedicoPorUsuario(usuarioLogueado);

            // Registro de auditoría clínica (Cumplimiento LOPDGDD / RGPD Datos de Salud)
            AuditService.registrarAccesoHistorial(usuarioLogueado, rolLogueado, idPaciente, request.getRemoteAddr());

            request.setAttribute("paciente", paciente);
            request.setAttribute("informes", informes);
            request.setAttribute("citas", citas);
            request.setAttribute("medicos", medicos);
            request.setAttribute("medicoSesion", medicoSesion);

            request.getRequestDispatcher("historial-paciente.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("SvPacientes");
        }
    }
}
