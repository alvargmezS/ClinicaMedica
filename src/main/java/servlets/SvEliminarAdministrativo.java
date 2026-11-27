package servlets;

import Logica.Controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SvEliminarAdministrativo", value = "/SvEliminarAdministrativo")
public class SvEliminarAdministrativo extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            controller.eliminarAdministrativo(id);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("SvAdministrativos");
    }
}
