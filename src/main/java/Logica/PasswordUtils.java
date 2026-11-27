package Logica;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    /**
     * Genera un hash seguro para la contraseña plana usando BCrypt con coste 12.
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Comprueba si una contraseña en texto plano coincide con el hash almacenado.
     * Incluye compatibilidad hacia atrás si la contraseña en BD estaba aún en texto plano.
     */
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }

        // Si el hash almacenado tiene el formato estándar de BCrypt ($2a$, $2b$, $2y$)
        if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
            try {
                return BCrypt.checkpw(plainPassword, storedPassword);
            } catch (Exception e) {
                return false;
            }
        }

        // Respaldo de compatibilidad: si la contraseña en BD aún estaba en texto plano
        return plainPassword.equals(storedPassword);
    }

    /**
     * Indica si una contraseña almacenada necesita ser actualizada a formato BCrypt
     * (por ejemplo, si aún estaba en texto plano).
     */
    public static boolean isHashed(String storedPassword) {
        if (storedPassword == null) return false;
        return storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$");
    }
}
