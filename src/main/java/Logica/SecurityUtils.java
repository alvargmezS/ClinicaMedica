package Logica;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SecurityUtils {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    public static final String CSRF_TOKEN_SESSION_ATTR = "csrfToken";

    /**
     * Escapa caracteres especiales de HTML para mitigar vulnerabilidades XSS (Cross-Site Scripting).
     */
    public static String escapeHtml(String input) {
        if (input == null) {
            return "";
        }
        StringBuilder out = new StringBuilder(Math.max(16, input.length()));
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '<':
                    out.append("&lt;");
                    break;
                case '>':
                    out.append("&gt;");
                    break;
                case '&':
                    out.append("&amp;");
                    break;
                case '"':
                    out.append("&quot;");
                    break;
                case '\'':
                    out.append("&#x27;");
                    break;
                case '/':
                    out.append("&#x2F;");
                    break;
                default:
                    out.append(c);
            }
        }
        return out.toString();
    }

    /**
     * Genera un token criptográfico anti-CSRF y lo asocia a la sesión si no existe.
     */
    public static String obtenerOGenerarTokenCsrf(HttpSession session) {
        if (session == null) {
            return "";
        }
        String token = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        if (token == null || token.trim().isEmpty()) {
            byte[] randomBytes = new byte[32];
            SECURE_RANDOM.nextBytes(randomBytes);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
            session.setAttribute(CSRF_TOKEN_SESSION_ATTR, token);
        }
        return token;
    }

    /**
     * Valida que el token CSRF enviado en la petición coincida con el almacenado en la sesión.
     */
    public static boolean validarTokenCsrf(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        String tokenSesion = (String) session.getAttribute(CSRF_TOKEN_SESSION_ATTR);
        if (tokenSesion == null || tokenSesion.isEmpty()) {
            return false;
        }

        String tokenPeticion = request.getParameter("csrfToken");
        if (tokenPeticion == null || tokenPeticion.isEmpty()) {
            tokenPeticion = request.getHeader("X-CSRF-Token");
        }

        if (tokenPeticion == null || tokenPeticion.isEmpty()) {
            return false;
        }

        // Comparación en tiempo constante para mitigar ataques de temporización (Timing Attacks)
        return MessageDigest.isEqual(
                tokenSesion.getBytes(StandardCharsets.UTF_8),
                tokenPeticion.getBytes(StandardCharsets.UTF_8)
        );
    }
}
