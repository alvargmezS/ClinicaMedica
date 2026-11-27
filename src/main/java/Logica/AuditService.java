package Logica;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuditService {

    private static final Logger LOGGER = Logger.getLogger("AuditoriaSalud");

    static {
        try {
            // Logger configurado para registrar eventos de auditoría clínica
            LOGGER.setUseParentHandlers(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Registra un evento de acceso a datos clínicos de un paciente (Art. 9 RGPD / LOPDGDD).
     */
    public static void registrarAccesoHistorial(String usuario, String rol, int idPaciente, String ipOrigen) {
        String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String logMsg = String.format("[AUDITORIA_SALUD] Timestamp: %s | Usuario: %s | Rol: %s | IP: %s | Accion: CONSULTA_HISTORIAL_CLINICO | PacienteId: %d",
                timestamp, (usuario != null ? usuario : "ANONIMO"), (rol != null ? rol : "DESCONOCIDO"), (ipOrigen != null ? ipOrigen : "-"), idPaciente);
        LOGGER.log(Level.INFO, logMsg);
    }

    /**
     * Registra un evento de creación o registro de informe clínico.
     */
    public static void registrarCreacionInforme(String usuario, String rol, int idPaciente, int idMedico, String ipOrigen) {
        String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String logMsg = String.format("[AUDITORIA_SALUD] Timestamp: %s | Usuario: %s | Rol: %s | IP: %s | Accion: ALTA_INFORME_CLINICO | PacienteId: %d | MedicoId: %d",
                timestamp, (usuario != null ? usuario : "ANONIMO"), (rol != null ? rol : "DESCONOCIDO"), (ipOrigen != null ? ipOrigen : "-"), idPaciente, idMedico);
        LOGGER.log(Level.INFO, logMsg);
    }

    /**
     * Registra un evento de descarga de informe médico en PDF (Art. 9 RGPD / LOPDGDD).
     */
    public static void registrarDescargaInformePdf(String usuario, String rol, int idInforme, int idPaciente, String ipOrigen) {
        String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String logMsg = String.format("[AUDITORIA_SALUD] Timestamp: %s | Usuario: %s | Rol: %s | IP: %s | Accion: DESCARGA_INFORME_PDF | InformeId: %d | PacienteId: %d",
                timestamp, (usuario != null ? usuario : "ANONIMO"), (rol != null ? rol : "DESCONOCIDO"), (ipOrigen != null ? ipOrigen : "-"), idInforme, idPaciente);
        LOGGER.log(Level.INFO, logMsg);
    }
}
