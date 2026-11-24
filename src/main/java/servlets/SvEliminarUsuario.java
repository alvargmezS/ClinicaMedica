package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import Logica.Controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SvEliminarUsuario", value = "/SvEliminarUsuario")
public class SvEliminarUsuario extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id =  Integer.parseInt(request.getParameter("id"));

        controller.deleteUsuario(id);

        response.sendRedirect("SvUsuario");
    }
}