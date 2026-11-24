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

@WebServlet(name = "SvUsuario", value = "/SvUsuario")
public class SvUsuario extends HttpServlet {

    Controller usuario =  new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Usuario> usu = new ArrayList<>();

        usu = usuario.getUsuarios();

        HttpSession sesion = request.getSession();
        sesion.setAttribute("listaUsuarios", usu);

        //System.out.println("Usuario " + usu.get(0).getNombre_usuario());

        response.sendRedirect("ver-usuarios.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre =  request.getParameter("nombre");
        String password =  request.getParameter("pass");
        String rol = request.getParameter("rol");

        usuario.crearUsuario(nombre, password, rol);

        response.sendRedirect("SvUsuario");
    }
}