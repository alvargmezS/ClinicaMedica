package servlets;

import java.io.IOException;

import Logica.Controller;
import Logica.PasswordUtils;
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
        sesion.setAttribute("usuarioEditar", usu);

        response.sendRedirect("editar-usuario.jsp");

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pass = request.getParameter("pass");
        String nombre = request.getParameter("nombre");
        String rol = request.getParameter("rol");

        Usuario usu = (Usuario) request.getSession().getAttribute("usuarioEditar");

        if (usu != null) {
            usu.setNombre_usuario(nombre);
            usu.setRol(rol);

            // Solo si se ingresó una nueva contraseña, se hashea y actualiza. Si se deja vacía, se mantiene la actual.
            if (pass != null && !pass.trim().isEmpty()) {
                usu.setPassword(PasswordUtils.hashPassword(pass));
            }

            controller.editUsuario(usu);

            // Limpiamos el atributo temporal de sesión
            request.getSession().removeAttribute("usuarioEditar");
        }

        response.sendRedirect("SvUsuario");

    }
}
