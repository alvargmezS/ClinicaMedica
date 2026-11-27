package servlets;

import Logica.Controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SvEliminarCita", value = "/SvEliminarCita")
public class SvEliminarCita extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            controller.eliminarCita(id);
            request.getSession().setAttribute("mensajeExito", "Cita cancelada y eliminada con éxito.");
        } catch (Exception e) {
            request.getSession().setAttribute("errorCita", "No se pudo eliminar la cita: " + e.getMessage());
        }

        String origen = request.getParameter("origen");
        if ("calendario".equals(origen)) {
            response.sendRedirect("calendario-citas.jsp");
        } else {
            response.sendRedirect("SvCitas");
        }
    }
}
