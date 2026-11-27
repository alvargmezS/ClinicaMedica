package servlets;

import Logica.AuditService;
import Logica.Controller;
import Logica.InformeMedico;
import Logica.Medico;
import Logica.Paciente;
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "SvDescargarInformePdf", value = "/SvDescargarInformePdf")
public class SvDescargarInformePdf extends HttpServlet {

    Controller controller = new Controller();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String usuarioLogueado = (session != null) ? (String) session.getAttribute("usuario") : null;
        if (usuarioLogueado == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("SvInformes");
            return;
        }

        try {
            int idInforme = Integer.parseInt(idStr.trim());
            InformeMedico inf = controller.getInforme(idInforme);
            if (inf == null) {
                response.sendRedirect("SvInformes");
                return;
            }

            // Trazabilidad de Auditoría RGPD (Acceso y descarga de documentación médica)
            String rol = (session != null) ? (String) session.getAttribute("rol") : "DESCONOCIDO";
            int pacId = (inf.getPaciente() != null) ? inf.getPaciente().getId_persona() : 0;
            AuditService.registrarDescargaInformePdf(
                    usuarioLogueado,
                    rol,
                    idInforme,
                    pacId,
                    request.getRemoteAddr()
            );

            // Generar el documento PDF en memoria
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            Document doc = new Document(PageSize.A4, 40, 40, 45, 40);
            PdfWriter.getInstance(doc, baos);
            doc.open();

            // Definición de fuentes y estilos
            Font fontHeaderClinica = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, new Color(40, 80, 160));
            Font fontSubClinica = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.DARK_GRAY);
            Font fontTituloDoc = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 13, new Color(30, 40, 60));
            Font fontHeaderTabla = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);
            Font fontLabel = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, new Color(60, 60, 60));
            Font fontValor = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.BLACK);
            Font fontCuerpo = FontFactory.getFont(FontFactory.HELVETICA, 10, new Color(30, 30, 30));
            Font fontPie = FontFactory.getFont(FontFactory.HELVETICA, 8, Color.GRAY);

            // 1. Membrete oficial de la clínica
            Paragraph pClinica = new Paragraph("CLÍNICA MÉDICA SANITARIA", fontHeaderClinica);
            pClinica.setAlignment(Element.ALIGN_CENTER);
            doc.add(pClinica);

            Paragraph pSub = new Paragraph("Departamento de Asistencia Médica y Registros Clínicos\nSistema de Gestión Clínica Automatizada\n\n", fontSubClinica);
            pSub.setAlignment(Element.ALIGN_CENTER);
            doc.add(pSub);

            // Barra de título del documento
            PdfPTable tablaTitulo = new PdfPTable(1);
            tablaTitulo.setWidthPercentage(100);
            PdfPCell cellTit = new PdfPCell(new Phrase("INFORME CLÍNICO OFICIAL DE CONSULTA - REF #" + inf.getId_informe(), fontTituloDoc));
            cellTit.setBackgroundColor(new Color(240, 244, 250));
            cellTit.setPadding(8);
            cellTit.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellTit.setBorderColor(new Color(200, 215, 235));
            tablaTitulo.addCell(cellTit);
            tablaTitulo.setSpacingAfter(15);
            doc.add(tablaTitulo);

            // 2. Metadatos del Paciente y Facultativo en dos columnas
            PdfPTable tablaMeta = new PdfPTable(2);
            tablaMeta.setWidthPercentage(100);
            tablaMeta.setSpacingAfter(15);

            PdfPCell c1 = new PdfPCell(new Phrase("DATOS DEL PACIENTE", fontHeaderTabla));
            c1.setBackgroundColor(new Color(78, 115, 223));
            c1.setPadding(5);
            tablaMeta.addCell(c1);

            PdfPCell c2 = new PdfPCell(new Phrase("MÉDICO FACULTATIVO", fontHeaderTabla));
            c2.setBackgroundColor(new Color(78, 115, 223));
            c2.setPadding(5);
            tablaMeta.addCell(c2);

            Paciente pac = inf.getPaciente();
            Medico med = inf.getMedico();
            SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            SimpleDateFormat sdfSoloFecha = new SimpleDateFormat("dd/MM/yyyy");

            String pacTexto = (pac != null)
                    ? "Nombre: " + pac.getNombre() + " " + pac.getApellido() + "\n"
                    + "DNI: " + (pac.getDni() != null ? pac.getDni() : "Sin DNI") + "\n"
                    + "Teléfono: " + (pac.getTelefono() != null ? pac.getTelefono() : "No registrado") + "\n"
                    + "Seguro Médico: " + (pac.getSeguro_medico() != null ? pac.getSeguro_medico() : "Particular")
                    : "Paciente no asignado";

            String medTexto = (med != null)
                    ? "Dr./Dra. " + med.getNombre() + " " + med.getApellido() + "\n"
                    + "Especialidad: " + (med.getEspecialidad() != null ? med.getEspecialidad() : "Medicina General") + "\n"
                    + "Nº Colegiado/ID: #" + med.getId_persona() + "\n"
                    + "Horario Habitual: " + (med.getHorarioMedico() != null ? (med.getHorarioMedico().getHora_inicio() + " - " + med.getHorarioMedico().getHora_fin()) : "No especificado")
                    : "Médico no asignado";

            PdfPCell cellPac = new PdfPCell(new Phrase(pacTexto, fontValor));
            cellPac.setPadding(8);
            cellPac.setBorderColor(new Color(220, 225, 230));
            tablaMeta.addCell(cellPac);

            PdfPCell cellMed = new PdfPCell(new Phrase(medTexto, fontValor));
            cellMed.setPadding(8);
            cellMed.setBorderColor(new Color(220, 225, 230));
            tablaMeta.addCell(cellMed);

            doc.add(tablaMeta);

            // Fecha de emisión
            String strFecha = (inf.getFecha_informe() != null) ? sdfDisplay.format(inf.getFecha_informe()) : sdfDisplay.format(new Date());
            Paragraph pFecha = new Paragraph("Fecha y hora de registro clínico: " + strFecha + "\n\n", fontLabel);
            doc.add(pFecha);

            // 3. Secciones Clínicas
            agregarBloque(doc, "1. MOTIVO DE LA CONSULTA MÉDICA", inf.getMotivo_consulta(), fontLabel, fontCuerpo, new Color(245, 247, 250));
            agregarBloque(doc, "2. JUICIO DIAGNÓSTICO", inf.getDiagnostico(), fontLabel, fontCuerpo, new Color(254, 243, 242));
            agregarBloque(doc, "3. TRATAMIENTO Y PRESCRIPCIÓN TERAPÉUTICA", inf.getTratamiento(), fontLabel, fontCuerpo, new Color(238, 247, 254));

            if (inf.getObservaciones() != null && !inf.getObservaciones().trim().isEmpty()) {
                agregarBloque(doc, "4. OBSERVACIONES CLÍNICAS Y PLAN DE SEGUIMIENTO", inf.getObservaciones(), fontLabel, fontCuerpo, new Color(250, 250, 250));
            }

            // 4. Bloque de firma facultativa y sello
            PdfPTable tablaFirma = new PdfPTable(2);
            tablaFirma.setWidthPercentage(100);
            tablaFirma.setSpacingBefore(30);

            PdfPCell celdaVacia = new PdfPCell(new Phrase(""));
            celdaVacia.setBorder(Rectangle.NO_BORDER);
            tablaFirma.addCell(celdaVacia);

            String firmaStr = "_________________________________________\n"
                    + (med != null ? ("Dr./Dra. " + med.getNombre() + " " + med.getApellido() + "\n" + (med.getEspecialidad() != null ? med.getEspecialidad() : "Facultativo")) : "Firma del Facultativo")
                    + "\nDocumento clínico firmado electrónicamente";
            PdfPCell celdaFirma = new PdfPCell(new Phrase(firmaStr, fontLabel));
            celdaFirma.setBorder(Rectangle.NO_BORDER);
            celdaFirma.setHorizontalAlignment(Element.ALIGN_CENTER);
            tablaFirma.addCell(celdaFirma);

            doc.add(tablaFirma);

            // 5. Pie de página legal (RGPD / Confidencialidad)
            Paragraph pieLegal = new Paragraph("\n\nAVISO DE CONFIDENCIALIDAD: Este documento contiene datos de salud protegidos por el Reglamento General de Protección de Datos (RGPD UE 2016/679) y la Ley Orgánica 3/2018 (LOPDGDD). Queda prohibida su reproducción o difusión no autorizada.", fontPie);
            pieLegal.setAlignment(Element.ALIGN_CENTER);
            doc.add(pieLegal);

            doc.close();

            // Configurar cabeceras de respuesta HTTP
            byte[] bytesPdf = baos.toByteArray();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"informe_medico_" + idInforme + ".pdf\"");
            response.setContentLength(bytesPdf.length);

            // Enviar bytes directamente al flujo de salida
            response.getOutputStream().write(bytesPdf);
            response.getOutputStream().flush();

        } catch (Exception e) {
            response.sendRedirect("SvInformes");
        }
    }

    private void agregarBloque(Document doc, String titulo, String contenido, Font fontTit, Font fontCont, Color fondo) throws DocumentException {
        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(100);
        table.setSpacingAfter(10);

        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(fondo);
        cell.setPadding(8);
        cell.setBorderColor(new Color(215, 220, 228));

        Paragraph pTit = new Paragraph(titulo, fontTit);
        pTit.setSpacingAfter(4);
        cell.addElement(pTit);

        String texto = (contenido != null && !contenido.trim().isEmpty()) ? contenido : "Sin especificar.";
        Paragraph pCont = new Paragraph(texto, fontCont);
        cell.addElement(pCont);

        table.addCell(cell);
        doc.add(table);
    }
}
