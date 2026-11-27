package persistence;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.HashMap;
import java.util.Map;

public class EntityManagerUtil {

    private static EntityManagerFactory emf;

    private EntityManagerUtil() {
    }

    /**
     * Devuelve una instancia singleton de EntityManagerFactory.
     * Soporta configuración dinámica mediante variables de entorno para entornos de producción/Docker.
     */
    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (emf == null || !emf.isOpen()) {
            Map<String, String> properties = new HashMap<>();

            // Variables de entorno para despliegue seguro (Docker, Kubernetes, Servidores cloud)
            String dbUrl = System.getenv("DB_URL");
            String dbUser = System.getenv("DB_USER");
            String dbPassword = System.getenv("DB_PASSWORD");
            String dbDriver = System.getenv("DB_DRIVER");
            String hbm2ddl = System.getenv("HIBERNATE_HBM2DDL_AUTO");

            if (dbUrl != null && !dbUrl.trim().isEmpty()) {
                properties.put("jakarta.persistence.jdbc.url", dbUrl.trim());
            }
            if (dbUser != null && !dbUser.trim().isEmpty()) {
                properties.put("jakarta.persistence.jdbc.user", dbUser.trim());
            }
            if (dbPassword != null) {
                properties.put("jakarta.persistence.jdbc.password", dbPassword);
            }
            if (dbDriver != null && !dbDriver.trim().isEmpty()) {
                properties.put("jakarta.persistence.jdbc.driver", dbDriver.trim());
            }
            if (hbm2ddl != null && !hbm2ddl.trim().isEmpty()) {
                properties.put("hibernate.hbm2ddl.auto", hbm2ddl.trim());
            }

            if (!properties.isEmpty()) {
                emf = Persistence.createEntityManagerFactory("clinicaMedica", properties);
            } else {
                emf = Persistence.createEntityManagerFactory("clinicaMedica");
            }
        }
        return emf;
    }

    public static synchronized void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
