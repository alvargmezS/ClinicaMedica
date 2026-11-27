package Logica;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInicializadorListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("===================================================================");
        System.out.println("[ClinicaMedica] Inicializando contexto de aplicación...");
        try {
            Controller controller = new Controller();
            controller.asegurarUsuarioAdminPorDefecto();
            System.out.println("[ClinicaMedica] Verificación de usuario administrador inicial completada.");
        } catch (Throwable t) {
            System.err.println("[ClinicaMedica] Advertencia al inicializar usuario admin por defecto: " + t.getMessage());
        }
        System.out.println("===================================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[ClinicaMedica] Contexto detenido.");
    }
}
