package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import Logica.Controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SvUsuario", value = "/SvUsuario")
public class SvUsuario extends HttpServlet {

    Controller usuario =  new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre =  request.getParameter("nombre");
        String password =  request.getParameter("pass");
        String rol = request.getParameter("rol");

        usuario.crearUsuario(nombre, password, rol);

        response.sendRedirect("index.jsp");
    }
}