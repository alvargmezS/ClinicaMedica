package servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

    Controller medico = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Medico> med = medico.getMedicos();
        List<Usuario> usuSinMedico = medico.getUsuariosSinMedico();

        HttpSession sesion = request.getSession();
        sesion.setAttribute("listaMedicos", med);
        sesion.setAttribute("usuariosSinMedico", usuSinMedico);

        response.sendRedirect("ver-medicos.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String especialidad = request.getParameter("especialidad");
        String fechaNacStr = request.getParameter("fecha_nac");

        // Horarios
        String horaInicio = request.getParameter("hora_inicio");
        String horaFin = request.getParameter("hora_fin");

        Date fechaNac = null;
        try {
            if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                fechaNac = new SimpleDateFormat("yyyy-MM-dd").parse(fechaNacStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        String idUsuarioExistenteStr = request.getParameter("id_usuario_existente");
        int idUsuarioExistente = (idUsuarioExistenteStr != null && !idUsuarioExistenteStr.isEmpty()) 
                ? Integer.parseInt(idUsuarioExistenteStr) : 0;

        String usuario = request.getParameter("usuario");
        String pass = request.getParameter("pass");
        String rol = request.getParameter("rol");

        if (idUsuarioExistente > 0) {
            medico.crearMedicoConUsuarioExistente(dni, nombre, apellido, direccion, telefono, fechaNac, especialidad, horaInicio, horaFin, idUsuarioExistente);
        } else if (usuario != null && !usuario.trim().isEmpty() && pass != null && !pass.trim().isEmpty()) {
            medico.crearMedico(dni, nombre, apellido, direccion, telefono, fechaNac, especialidad, horaInicio, horaFin, usuario, pass, rol);
        } else {
            // Si no introdujo usuario nuevo ni eligió uno existente, se le crea uno por defecto con su DNI
            medico.crearMedico(dni, nombre, apellido, direccion, telefono, fechaNac, especialidad, horaInicio, horaFin, dni, dni, "Medico");
        }

        // Redireccionamos a SvMedicos para listar los médicos actualizados
        response.sendRedirect("SvMedicos");
    }
}
