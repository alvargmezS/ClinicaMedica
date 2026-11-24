package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import Logica.Controller;
import Logica.Medico;
import Logica.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SvMedicos", value = "/SvMedicos")
public class SvMedicos extends HttpServlet {

    Controller medico =  new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Medico> med = new ArrayList<>();

        med = medico.getMedicos();

        HttpSession sesion = request.getSession();
        sesion.setAttribute("listaMedicos", med);

        //System.out.println("Usuario " + usu.get(0).getNombre_usuario());

        response.sendRedirect("ver-medicos.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        medico.crearMedico();

        response.sendRedirect("");
    }
}