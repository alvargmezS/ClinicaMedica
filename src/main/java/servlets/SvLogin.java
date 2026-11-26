package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import Logica.Controller;
import Logica.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SvLogin", value = "/SvLogin")
public class SvLogin extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String pass = request.getParameter("pass");

        boolean valid = false;

        valid = controller.validIngreso(usuario, pass);

        if (valid) {

            HttpSession sesion = request.getSession(true);
            sesion.setAttribute("usuario", usuario);
            response.sendRedirect("index.jsp");
        }else{
            response.sendRedirect("login-error.jsp");
        }

    }
}