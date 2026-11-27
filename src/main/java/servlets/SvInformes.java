package servlets;

import Logica.Controller;
import Logica.InformeMedico;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SvInformes", value = "/SvInformes")
public class SvInformes extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<InformeMedico> listaInformes = controller.getInformes();

        HttpSession session = request.getSession();
        session.setAttribute("listaInformes", listaInformes);

        response.sendRedirect("ver-informes.jsp");
    }
}
