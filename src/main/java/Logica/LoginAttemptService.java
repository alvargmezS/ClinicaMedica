package Logica;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class LoginAttemptService {

    private static final int MAX_INTENTOS = 5;
    private static final long TIEMPO_BLOQUEO_MS = 15 * 60 * 1000; // 15 minutos en milisegundos

    private static class IntentoInfo {
        int intentos;
        long primerFalloMs;
        long bloqueadoHastaMs;

        IntentoInfo() {
            this.intentos = 1;
            this.primerFalloMs = System.currentTimeMillis();
            this.bloqueadoHastaMs = 0;
        }
    }

    private static final Map<String, IntentoInfo> cacheIntentos = new ConcurrentHashMap<>();

    /**
     * Comprueba si el usuario o dirección IP está bloqueado temporalmente por exceso de intentos fallidos.
     */
    public static boolean estaBloqueado(String identificador) {
        if (identificador == null || identificador.trim().isEmpty()) {
            return false;
        }
        IntentoInfo info = cacheIntentos.get(identificador.toLowerCase().trim());
        if (info == null) {
            return false;
        }

        long ahora = System.currentTimeMillis();
        if (info.bloqueadoHastaMs > ahora) {
            return true; // Aún está en periodo de bloqueo
        } else if (info.bloqueadoHastaMs > 0 && info.bloqueadoHastaMs <= ahora) {
            // El periodo de bloqueo ya venció, se restablece
            cacheIntentos.remove(identificador.toLowerCase().trim());
            return false;
        }

        // Si pasaron más de 15 min desde el primer fallo, se reinicia la cuenta
        if (ahora - info.primerFalloMs > TIEMPO_BLOQUEO_MS) {
            cacheIntentos.remove(identificador.toLowerCase().trim());
            return false;
        }

        return false;
    }

    /**
     * Registra un intento fallido de autenticación.
     */
    public static void registrarFallo(String identificador) {
        if (identificador == null || identificador.trim().isEmpty()) {
            return;
        }
        String clave = identificador.toLowerCase().trim();
        long ahora = System.currentTimeMillis();

        cacheIntentos.compute(clave, (k, info) -> {
            if (info == null || (ahora - info.primerFalloMs > TIEMPO_BLOQUEO_MS)) {
                return new IntentoInfo();
            } else {
                info.intentos++;
                if (info.intentos >= MAX_INTENTOS) {
                    info.bloqueadoHastaMs = ahora + TIEMPO_BLOQUEO_MS;
                }
                return info;
            }
        });
    }

    /**
     * Restablece el contador tras un inicio de sesión exitoso.
     */
    public static void registrarExito(String identificador) {
        if (identificador != null) {
            cacheIntentos.remove(identificador.toLowerCase().trim());
        }
    }

    public static int getMinutosRestantesBloqueo(String identificador) {
        if (identificador == null) return 0;
        IntentoInfo info = cacheIntentos.get(identificador.toLowerCase().trim());
        if (info != null && info.bloqueadoHastaMs > System.currentTimeMillis()) {
            long ms = info.bloqueadoHastaMs - System.currentTimeMillis();
            return (int) Math.ceil((double) ms / 60000.0);
        }
        return 0;
    }
}
