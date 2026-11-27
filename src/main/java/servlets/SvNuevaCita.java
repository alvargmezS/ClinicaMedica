package servlets;

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
import java.util.List;

@WebServlet(name = "SvNuevaCita", value = "/SvNuevaCita")
public class SvNuevaCita extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Medico> medicos = controller.getMedicos();
        List<Paciente> pacientes = controller.getPacientes();

        HttpSession sesion = request.getSession();
        sesion.setAttribute("listaMedicos", medicos);
        sesion.setAttribute("listaPacientes", pacientes);

        response.sendRedirect("alta-cita.jsp");
    }
}
