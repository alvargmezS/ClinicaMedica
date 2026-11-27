package servlets;

import Logica.Controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SvEliminarMedico", value = "/SvEliminarMedico")
public class SvEliminarMedico extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            controller.eliminarMedico(id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("SvMedicos");
    }
}
