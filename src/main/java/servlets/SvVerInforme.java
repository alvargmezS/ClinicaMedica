package servlets;

import Logica.Controller;
import Logica.InformeMedico;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SvVerInforme", value = "/SvVerInforme")
public class SvVerInforme extends HttpServlet {

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
            int idInforme = Integer.parseInt(idStr);
            InformeMedico informe = controller.getInforme(idInforme);

            if (informe == null) {
                response.sendRedirect("SvPacientes");
                return;
            }

            request.setAttribute("informe", informe);
            request.getRequestDispatcher("ver-informe.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("SvPacientes");
        }
    }
}
