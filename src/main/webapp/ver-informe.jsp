<%@ page import="Logica.InformeMedico" %>
<%@ page import="Logica.Paciente" %>
<%@ page import="Logica.Medico" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 27/11/2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<%
    InformeMedico informe = (InformeMedico) request.getAttribute("informe");
    SimpleDateFormat sdfFecha = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfTimestamp = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<style>
@media print {
    /* Ocultar elementos no relevantes al imprimir */
    #accordionSidebar, .topbar, .btn-no-print, footer, #sidebarToggleTop {
        display: none !important;
    }
    #content-wrapper {
        margin: 0 !important;
        padding: 0 !important;
    }
    .card {
        border: none !important;
        box-shadow: none !important;
    }
}
.texto-informe { white-space: pre-wrap; }
</style>

<div class="container-fluid">

    <% if (informe == null) { %>
        <div class="alert alert-danger shadow-sm">
            <i class="fas fa-exclamation-triangle mr-1"></i> Informe no encontrado. <a href="SvPacientes" class="alert-link">Volver a Pacientes</a>
        </div>
    <% } else { 
        Paciente p = informe.getPaciente();
        Medico m = informe.getMedico();
    %>

    <!-- Barra de acciones superior (no se imprime) -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4 btn-no-print">
        <div>
            <h1 class="h3 mb-0 text-gray-800">
                <i class="fas fa-file-medical text-primary mr-1"></i> Informe Clínico #<%=informe.getId_informe()%>
            </h1>
            <p class="mb-0 text-gray-600">Documento clínico oficial emitido por el facultativo</p>
        </div>
        <div>
            <% if (p != null) { %>
            <a href="SvHistorialPaciente?id=<%=p.getId_persona()%>" class="btn btn-secondary shadow-sm mr-2">
                <i class="fas fa-arrow-left fa-sm mr-1"></i> Historial del Paciente
            </a>
            <% } %>
            <a href="SvInformes" class="btn btn-outline-info shadow-sm mr-2">
                <i class="fas fa-list fa-sm mr-1"></i> Todos los Informes
            </a>
            <a href="SvDescargarInformePdf?id=<%=informe.getId_informe()%>" class="btn btn-danger shadow-sm mr-2" title="Descargar informe oficial en PDF">
                <i class="fas fa-file-pdf fa-sm mr-1"></i> Descargar PDF
            </a>
            <a href="#" class="btn btn-primary shadow-sm" title="Usa Ctrl+P o Cmd+P para imprimir">
                <i class="fas fa-print fa-sm mr-1"></i> Imprimir Informe
            </a>
        </div>
    </div>

    <!-- Ficha Oficial del Informe Clínico -->
    <div class="card shadow mb-5 border-left-primary">
        <div class="card-body p-5">

            <!-- Cabecera Oficial de la Clínica -->
            <div class="d-flex justify-content-between align-items-center border-bottom pb-4 mb-4">
                <div>
                    <h2 class="text-primary font-weight-bold mb-1">
                        <i class="fas fa-hospital-alt mr-2"></i> CLÍNICA MÉDICA
                    </h2>
                    <p class="text-muted mb-0 small">Servicio de Asistencia Médica y Salud Integral</p>
                    <p class="text-muted mb-0 small">Dpto. de Historia Clínica y Registros Facultativos</p>
                </div>
                <div class="text-right">
                    <span class="badge badge-primary px-3 py-2 font-weight-bold" style="font-size: 1rem;">
                        INFORME MÉDICO N° <%=String.format("%05d", informe.getId_informe())%>
                    </span>
                    <p class="text-muted mt-2 mb-0 small">
                        <strong>Fecha de Emisión:</strong> 
                        <%=informe.getFecha_informe() != null ? sdfTimestamp.format(informe.getFecha_informe()) : "-"%>
                    </p>
                </div>
            </div>

            <!-- Fila: Paciente y Médico -->
            <div class="row mb-4">
                <!-- Datos del Paciente -->
                <div class="col-md-6 mb-3">
                    <div class="p-3 bg-light rounded border h-100">
                        <h6 class="font-weight-bold text-dark border-bottom pb-2 mb-3">
                            <i class="fas fa-user-injured text-primary mr-1"></i> DATOS DEL PACIENTE
                        </h6>
                        <% if (p != null) { %>
                            <p class="mb-1"><strong>Nombre Completo:</strong> <%=p.getNombre()%> <%=p.getApellido()%></p>
                            <p class="mb-1"><strong>DNI / Pasaporte:</strong> <%=p.getDni() != null ? p.getDni() : "-"%></p>
                            <p class="mb-1"><strong>Teléfono:</strong> <%=p.getTelefono() != null ? p.getTelefono() : "-"%></p>
                            <p class="mb-1"><strong>Dirección:</strong> <%=p.getDireccion() != null ? p.getDireccion() : "-"%></p>
                            <p class="mb-1"><strong>Fecha de Nacimiento:</strong> <%=p.getFecha_nacimiento() != null ? sdfFecha.format(p.getFecha_nacimiento()) : "-"%></p>
                            <p class="mb-0">
                                <strong>Seguro:</strong> <span class="badge badge-info"><%=p.getSeguro_medico() != null ? p.getSeguro_medico() : "Sin seguro"%></span>
                                <strong class="ml-2">Grupo Sanguíneo:</strong> <span class="badge badge-danger"><%=p.getGrupo_sangre() != null ? p.getGrupo_sangre() : "-"%></span>
                            </p>
                        <% } else { %>
                            <p class="text-muted mb-0">Paciente no disponible o dado de baja.</p>
                        <% } %>
                    </div>
                </div>

                <!-- Datos del Facultativo -->
                <div class="col-md-6 mb-3">
                    <div class="p-3 bg-light rounded border h-100">
                        <h6 class="font-weight-bold text-dark border-bottom pb-2 mb-3">
                            <i class="fas fa-user-md text-success mr-1"></i> FACULTATIVO RESPONSABLE
                        </h6>
                        <% if (m != null) { %>
                            <p class="mb-1"><strong>Médico:</strong> Dr./Dra. <%=m.getNombre()%> <%=m.getApellido()%></p>
                            <p class="mb-1"><strong>Especialidad:</strong> <%=m.getEspecialidad() != null ? m.getEspecialidad() : "Medicina General"%></p>
                            <p class="mb-1"><strong>DNI Colegiado:</strong> <%=m.getDni() != null ? m.getDni() : "-"%></p>
                            <p class="mb-0"><strong>Teléfono Contacto:</strong> <%=m.getTelefono() != null ? m.getTelefono() : "-"%></p>
                        <% } else { %>
                            <p class="text-muted mb-0">Médico no especificado.</p>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Cuerpo Clínico -->
            <div class="mb-4">
                <h6 class="font-weight-bold text-dark border-bottom pb-2 mb-2">
                    <i class="fas fa-comment-medical text-primary mr-1"></i> MOTIVO DE CONSULTA
                </h6>
                <div class="p-3 bg-white rounded border mb-3">
                    <p class="mb-0 text-gray-900 font-weight-bold">
                        <%=informe.getMotivo_consulta() != null && !informe.getMotivo_consulta().isEmpty() ? informe.getMotivo_consulta() : "Consulta Médica General"%>
                    </p>
                </div>
            </div>

            <div class="mb-4">
                <h6 class="font-weight-bold text-danger border-bottom pb-2 mb-2">
                    <i class="fas fa-stethoscope mr-1"></i> JUICIO DIAGNÓSTICO
                </h6>
                <div class="p-3 bg-light rounded border mb-3">
                    <p class="mb-0 text-gray-900" class="texto-informe text-gray-900 mb-0" style="font-size: 1.05rem;"><%=informe.getDiagnostico() != null && !informe.getDiagnostico().isEmpty() ? informe.getDiagnostico() : "Sin diagnóstico registrado."%></p>
                </div>
            </div>

            <div class="mb-4">
                <h6 class="font-weight-bold text-info border-bottom pb-2 mb-2">
                    <i class="fas fa-pills mr-1"></i> TRATAMIENTO Y PRESCRIPCIÓN TERAPÉUTICA
                </h6>
                <div class="p-3 bg-light rounded border mb-3">
                    <p class="mb-0 text-gray-900" class="texto-informe text-gray-900 mb-0" style="font-size: 1.05rem;"><%=informe.getTratamiento() != null && !informe.getTratamiento().isEmpty() ? informe.getTratamiento() : "Sin tratamiento prescrito."%></p>
                </div>
            </div>

            <% if (informe.getObservaciones() != null && !informe.getObservaciones().trim().isEmpty()) { %>
            <div class="mb-4">
                <h6 class="font-weight-bold text-muted border-bottom pb-2 mb-2">
                    <i class="fas fa-notes-medical mr-1"></i> OBSERVACIONES CLÍNICAS Y PLAN DE SEGUIMIENTO
                </h6>
                <div class="p-3 bg-white rounded border mb-3">
                    <p class="mb-0 text-gray-800" class="texto-informe text-gray-800 mb-0"><%=informe.getObservaciones()%></p>
                </div>
            </div>
            <% } %>

            <!-- Firma y Sello Facultativo -->
            <div class="row mt-5 pt-4">
                <div class="col-6 text-center">
                    <p class="text-muted small mb-0">Sello Oficial de la Clínica</p>
                    <div style="height: 80px; display: flex; align-items: center; justify-content: center;">
                        <i class="fas fa-certificate fa-3x text-gray-300"></i>
                    </div>
                </div>
                <div class="col-6 text-center">
                    <div style="border-bottom: 1px solid #333; width: 80%; margin: 0 auto; height: 60px;"></div>
                    <p class="text-dark font-weight-bold mb-0 mt-2">
                        Firma del Facultativo Responsable
                    </p>
                    <small class="text-muted">
                        <% if (m != null) { %>
                            Dr./Dra. <%=m.getNombre()%> <%=m.getApellido()%> - <%=m.getEspecialidad() != null ? m.getEspecialidad() : "Colegiado"%>
                        <% } %>
                    </small>
                </div>
            </div>

        </div>
    </div>

    <% } %>

</div>

<%@ include file="components/body2.jsp"%>
