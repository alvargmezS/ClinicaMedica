package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import Logica.Controller;
import Logica.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SvEditarUsuario", value = "/SvEditarUsuario")
public class SvEditarUsuario extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Usuario usu = controller.getUsuario(id);

        HttpSession sesion = request.getSession();
        sesion.setAttribute("usuario", usu);

        response.sendRedirect("editar-usuario.jsp");

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pass = request.getParameter("pass");
        String nombre = request.getParameter("nombre");
        String rol = request.getParameter("rol");

        Usuario usu = (Usuario) request.getSession().getAttribute("usuario");

        usu.setNombre_usuario(nombre);
        usu.setPassword(pass);
        usu.setRol(rol);

        controller.editUsuario(usu);

        response.sendRedirect("SvUsuario");

    }
}