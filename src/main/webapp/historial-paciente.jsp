<style>
.texto-prewrap { white-space: pre-wrap; }
</style>
<%@ page import="java.util.List" %>
<%@ page import="Logica.Paciente" %>
<%@ page import="Logica.SecurityUtils" %>
<%@ page import="Logica.InformeMedico" %>
<%@ page import="Logica.Cita" %>
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
    Paciente pac = (Paciente) request.getAttribute("paciente");
    List<InformeMedico> informes = (List<InformeMedico>) request.getAttribute("informes");
    List<Cita> citas = (List<Cita>) request.getAttribute("citas");
    List<Medico> medicos = (List<Medico>) request.getAttribute("medicos");
    Medico medicoSesion = (Medico) request.getAttribute("medicoSesion");

    SimpleDateFormat sdfFecha = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfTimestamp = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    boolean puedeEscribir = rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor");
%>

<div class="container-fluid">

    <% if (pac == null) { %>
        <div class="alert alert-danger shadow-sm">
            <i class="fas fa-exclamation-triangle mr-1"></i> Paciente no encontrado. <a href="SvPacientes" class="alert-link">Volver a la lista de pacientes</a>
        </div>
    <% } else { %>

    <!-- Header y migas de pan -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-1 text-gray-800">
                <i class="fas fa-file-medical text-primary mr-2"></i>
                Historial Clínico: <%=pac.getNombre()%> <%=pac.getApellido()%>
            </h1>
            <p class="mb-0 text-gray-600">Ficha médica, histórico de citas y registro de informes diagnósticos</p>
        </div>
        <div>
            <% if (puedeEscribir) { %>
            <a href="#formNuevoInforme" class="btn btn-success shadow-sm mr-2">
                <i class="fas fa-plus-circle fa-sm mr-1"></i> Nuevo Informe Médico
            </a>
            <% } %>
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Administrativo") || rol.equalsIgnoreCase("Recepcionista") || rol.equalsIgnoreCase("Secretaria")) { %>
            <a href="SvEditarPaciente?id=<%=pac.getId_persona()%>" class="btn btn-outline-primary shadow-sm mr-2">
                <i class="fas fa-edit fa-sm mr-1"></i> Editar Paciente
            </a>
            <% } %>
            <a href="SvPacientes" class="btn btn-secondary shadow-sm">
                <i class="fas fa-arrow-left fa-sm mr-1"></i> Volver a Pacientes
            </a>
        </div>
    </div>

    <!-- Ficha del Paciente -->
    <div class="card shadow mb-4 border-left-primary">
        <div class="card-header py-3 bg-white d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">
                <i class="fas fa-id-card mr-1"></i> Datos del Paciente
            </h6>
            <span class="badge badge-primary px-3 py-2">Id: #<%=pac.getId_persona()%></span>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-3 mb-3">
                    <span class="text-muted d-block small">Nombre Completo:</span>
                    <strong class="text-gray-900 font-weight-bold"><%=pac.getNombre()%> <%=pac.getApellido()%></strong>
                </div>
                <div class="col-md-2 mb-3">
                    <span class="text-muted d-block small">DNI / Documento:</span>
                    <strong class="text-gray-900"><%=pac.getDni() != null ? pac.getDni() : "-"%></strong>
                </div>
                <div class="col-md-2 mb-3">
                    <span class="text-muted d-block small">Teléfono:</span>
                    <strong class="text-gray-900"><%=pac.getTelefono() != null ? pac.getTelefono() : "-"%></strong>
                </div>
                <div class="col-md-3 mb-3">
                    <span class="text-muted d-block small">Dirección:</span>
                    <span class="text-gray-800"><%=pac.getDireccion() != null ? pac.getDireccion() : "-"%></span>
                </div>
                <div class="col-md-2 mb-3">
                    <span class="text-muted d-block small">Fecha de Nacimiento:</span>
                    <span class="text-gray-800"><%=pac.getFecha_nacimiento() != null ? sdfFecha.format(pac.getFecha_nacimiento()) : "-"%></span>
                </div>
            </div>
            <div class="row pt-2 border-top">
                <div class="col-md-3">
                    <span class="text-muted small mr-2">Seguro Médico:</span>
                    <span class="badge badge-info"><%=pac.getSeguro_medico() != null ? pac.getSeguro_medico() : "Sin seguro"%></span>
                </div>
                <div class="col-md-3">
                    <span class="text-muted small mr-2">Grupo Sanguíneo:</span>
                    <span class="badge badge-danger"><%=pac.getGrupo_sangre() != null ? pac.getGrupo_sangre() : "No especificado"%></span>
                </div>
                <div class="col-md-3">
                    <span class="text-muted small mr-2">Total Citas:</span>
                    <span class="badge badge-secondary"><%=citas != null ? citas.size() : 0%></span>
                </div>
                <div class="col-md-3">
                    <span class="text-muted small mr-2">Total Informes:</span>
                    <span class="badge badge-success"><%=informes != null ? informes.size() : 0%></span>
                </div>
            </div>
            <% 
               boolean pacEsMenor = false;
               int pacEdad = -1;
               try {
                   pacEsMenor = pac.esMenorDeEdad();
                   pacEdad = pac.getEdad();
               } catch (Exception ignored) {}

               Logica.Responsable pacResp = null;
               try {
                   pacResp = pac.getResponsable();
               } catch (Exception ignored) {}
            %>
            <% if (pacEsMenor || pacResp != null) { %>
            <div class="row pt-3 mt-2 border-top bg-light rounded p-2 mx-0 align-items-center">
                <div class="col-md-12 mb-1">
                    <span class="badge <%=pacEsMenor ? "badge-warning text-dark" : "badge-secondary"%> font-weight-bold mr-2">
                        <i class="fas <%=pacEsMenor ? "fa-child" : "fa-user-shield"%> mr-1"></i>
                        <%=pacEsMenor ? "Paciente Menor de Edad (" + pacEdad + " años)" : "Tutor / Responsable Asociado"%>
                    </span>
                    <% if (pacResp != null) { %>
                        <span class="text-gray-900 font-weight-bold">
                            Tutor Legal: <%=SecurityUtils.escapeHtml(pacResp.getNombre() != null ? pacResp.getNombre() : "")%> <%=SecurityUtils.escapeHtml(pacResp.getApellido() != null ? pacResp.getApellido() : "")%>
                        </span>
                        <span class="text-muted small ml-2">
                            (Parentesco: <strong><%=SecurityUtils.escapeHtml(pacResp.getTipo_responsable() != null ? pacResp.getTipo_responsable() : "Tutor")%></strong> | 
                            DNI: <strong><%=SecurityUtils.escapeHtml(pacResp.getDni() != null ? pacResp.getDni() : "-")%></strong> | 
                            Tel: <strong><%=SecurityUtils.escapeHtml(pacResp.getTelefono() != null ? pacResp.getTelefono() : "-")%></strong> | 
                            Dir: <%=SecurityUtils.escapeHtml(pacResp.getDireccion() != null && !pacResp.getDireccion().isEmpty() ? pacResp.getDireccion() : (pac.getDireccion() != null ? pac.getDireccion() : "-"))%>)
                        </span>
                    <% } else { %>
                        <span class="text-danger small font-weight-bold">
                            <i class="fas fa-exclamation-triangle mr-1"></i> Atención: Este paciente es menor de edad y actualmente no tiene tutor legal asignado.
                        </span>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Sección 1: Informes Médicos -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-success">
                <i class="fas fa-notes-medical mr-1"></i> Informes Clínicos y Diagnósticos
            </h6>
            <% if (puedeEscribir) { %>
            <a href="#formNuevoInforme" class="btn btn-sm btn-success">
                <i class="fas fa-plus mr-1"></i> Redactar Informe
            </a>
            <% } %>
        </div>
        <div class="card-body">
            <% if (informes != null && !informes.isEmpty()) { %>
                <div class="list-group">
                    <% for (InformeMedico inf : informes) { %>
                        <div class="list-group-item list-group-item-action flex-column align-items-start mb-3 border rounded shadow-sm">
                            <div class="d-flex w-100 justify-content-between align-items-center border-bottom pb-2 mb-2">
                                <h5 class="mb-0 text-primary font-weight-bold">
                                    <i class="fas fa-file-alt mr-1"></i> Informe #<%=inf.getId_informe()%> - <%=inf.getMotivo_consulta() != null && !inf.getMotivo_consulta().isEmpty() ? inf.getMotivo_consulta() : "Consulta Médica"%>
                                </h5>
                                <div>
                                    <small class="text-muted mr-3">
                                        <i class="fas fa-clock mr-1"></i>
                                        <%=inf.getFecha_informe() != null ? sdfTimestamp.format(inf.getFecha_informe()) : "-"%>
                                    </small>
                                    <a href="SvVerInforme?id=<%=inf.getId_informe()%>" class="btn btn-sm btn-outline-primary" target="_blank" title="Ver formato completo para imprimir">
                                        <i class="fas fa-print mr-1"></i> Ver / Imprimir
                                    </a>
                                    <a href="SvDescargarInformePdf?id=<%=inf.getId_informe()%>" class="btn btn-sm btn-outline-danger ml-1" title="Descargar informe en PDF">
                                        <i class="fas fa-file-pdf mr-1"></i> PDF
                                    </a>
                                </div>
                            </div>
                            
                            <div class="row text-gray-800 mb-2">
                                <div class="col-md-12 mb-1">
                                    <small class="text-muted">Médico Responsable: </small>
                                    <strong>
                                        <%=inf.getMedico() != null ? ("Dr./Dra. " + inf.getMedico().getNombre() + " " + inf.getMedico().getApellido() + " (" + (inf.getMedico().getEspecialidad() != null ? inf.getMedico().getEspecialidad() : "General") + ")") : "No especificado"%>
                                    </strong>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-2">
                                    <div class="p-2 bg-light rounded border">
                                        <span class="text-danger font-weight-bold small d-block">
                                            <i class="fas fa-stethoscope mr-1"></i> Diagnóstico:
                                        </span>
                                        <p class="mb-0 text-gray-900" class="texto-prewrap"><%=inf.getDiagnostico() != null && !inf.getDiagnostico().isEmpty() ? inf.getDiagnostico() : "Sin diagnóstico registrado."%></p>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <div class="p-2 bg-light rounded border">
                                        <span class="text-info font-weight-bold small d-block">
                                            <i class="fas fa-pills mr-1"></i> Tratamiento y Medicación Prescrita:
                                        </span>
                                        <p class="mb-0 text-gray-900" class="texto-prewrap"><%=inf.getTratamiento() != null && !inf.getTratamiento().isEmpty() ? inf.getTratamiento() : "Sin tratamiento prescrito."%></p>
                                    </div>
                                </div>
                            </div>

                            <% if (inf.getObservaciones() != null && !inf.getObservaciones().trim().isEmpty()) { %>
                            <div class="mt-2 pt-2 border-top">
                                <span class="text-muted font-weight-bold small d-block">Observaciones Adicionales / Evolución:</span>
                                <small class="text-gray-700" class="texto-prewrap"><%=inf.getObservaciones()%></small>
                            </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="text-center py-4 text-muted">
                    <i class="fas fa-clipboard-list fa-3x mb-2 d-block text-gray-400"></i>
                    No constan informes médicos registrados para este paciente.
                    <% if (puedeEscribir) { %>
                    <div class="mt-2">
                        <a href="#formNuevoInforme" class="btn btn-sm btn-success">
                            <i class="fas fa-plus mr-1"></i> Redactar el primer informe clínico
                        </a>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Sección 2: Histórico de Citas Médicas -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">
                <i class="fas fa-calendar-check mr-1"></i> Histórico de Citas Médicas del Paciente
            </h6>
            <a href="SvNuevaCita" class="btn btn-sm btn-outline-primary">
                <i class="fas fa-calendar-plus mr-1"></i> Agendar Cita
            </a>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                    <thead class="thead-light">
                        <tr>
                            <th>Id Cita</th>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Médico Asignado</th>
                            <th>Especialidad</th>
                            <th>Motivo de la Cita</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (citas != null && !citas.isEmpty()) {
                           for (Cita c : citas) { %>
                        <tr>
                            <td><span class="badge badge-secondary">#<%=c.getId_cita()%></span></td>
                            <td><strong><%=c.getFecha_cita() != null ? sdfFecha.format(c.getFecha_cita()) : "-"%></strong></td>
                            <td><span class="badge badge-light border"><i class="fas fa-clock mr-1"></i><%=c.getHora_cita() != null ? c.getHora_cita() : "-"%></span></td>
                            <td>
                                <%=c.getCitaMedico() != null ? ("Dr./Dra. " + c.getCitaMedico().getNombre() + " " + c.getCitaMedico().getApellido()) : "<span class='text-muted'>Sin asignar</span>"%>
                            </td>
                            <td>
                                <%= (c.getCitaMedico() != null && c.getCitaMedico().getEspecialidad() != null) ? c.getCitaMedico().getEspecialidad() : "-" %>
                            </td>
                            <td><%=c.getMotivo() != null ? c.getMotivo() : "-"%></td>
                        </tr>
                    <%     }
                       } else { %>
                        <tr>
                            <td colspan="6" class="text-center py-3 text-muted">
                                Este paciente no tiene citas registradas.
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Sección 3: Formulario para Generar Nuevo Informe Médico (HTML nativo sin JS) -->
    <% if (puedeEscribir) { %>
    <div class="card shadow mb-4 border-left-success" id="formNuevoInforme">
        <div class="card-header py-3 bg-white">
            <h6 class="m-0 font-weight-bold text-success">
                <i class="fas fa-pen-alt mr-1"></i> Redactar y Generar Nuevo Informe Clínico
            </h6>
        </div>
        <div class="card-body">
            <form action="SvGenerarInforme" method="post">
                <input type="hidden" name="id_paciente" value="<%=pac.getId_persona()%>">

                <div class="form-row">
                    <!-- Paciente (Fijo / de solo lectura) -->
                    <div class="form-group col-md-6">
                        <label class="font-weight-bold">Paciente:</label>
                        <input type="text" class="form-control bg-light" readonly
                               value="<%=pac.getNombre()%> <%=pac.getApellido()%> (DNI: <%=pac.getDni()%>)">
                    </div>

                    <!-- Médico Responsable -->
                    <div class="form-group col-md-6">
                        <label class="font-weight-bold">Médico Responsable:</label>
                        <% if (rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
                            <% if (medicoSesion != null) { %>
                                <input type="hidden" name="id_medico" value="<%=medicoSesion.getId_persona()%>">
                                <input type="text" class="form-control bg-light" readonly
                                       value="Dr./Dra. <%=medicoSesion.getNombre()%> <%=medicoSesion.getApellido()%> - <%=medicoSesion.getEspecialidad()%>">
                            <% } else { %>
                                <select name="id_medico" class="form-control" required>
                                    <option value="" disabled selected>Seleccione su perfil médico...</option>
                                    <% if (medicos != null) {
                                           for (Medico m : medicos) { %>
                                        <option value="<%=m.getId_persona()%>">Dr./Dra. <%=m.getNombre()%> <%=m.getApellido()%> (<%=m.getEspecialidad()%>)</option>
                                    <%     }
                                       } %>
                                </select>
                            <% } %>
                        <% } else { %>
                            <!-- Si es Administrador, puede elegir qué médico emite el informe -->
                            <select name="id_medico" class="form-control" required>
                                <option value="" disabled selected>Seleccionar médico firmante...</option>
                                <% if (medicos != null) {
                                       for (Medico m : medicos) { %>
                                    <option value="<%=m.getId_persona()%>">Dr./Dra. <%=m.getNombre()%> <%=m.getApellido()%> (<%=m.getEspecialidad()%>)</option>
                                <%     }
                                   } %>
                            </select>
                        <% } %>
                    </div>
                </div>

                <div class="form-group">
                    <label class="font-weight-bold">Motivo de la Consulta / Síntomas Iniciales:</label>
                    <input type="text" name="motivo" class="form-control" placeholder="Ej: Control evolutivo, dolor torácico, cefalea recurrente..." required>
                </div>

                <div class="form-group">
                    <label class="font-weight-bold text-danger">
                        <i class="fas fa-stethoscope mr-1"></i> Diagnóstico Médico:
                    </label>
                    <textarea name="diagnostico" class="form-control" rows="3" placeholder="Descripción detallada del diagnóstico clínico, hallazgos en la exploración y juicio facultativo..." required></textarea>
                </div>

                <div class="form-group">
                    <label class="font-weight-bold text-info">
                        <i class="fas fa-pills mr-1"></i> Tratamiento y Medicación Prescrita:
                    </label>
                    <textarea name="tratamiento" class="form-control" rows="3" placeholder="Fármacos prescritos, posología, pauta de administración y recomendaciones terapéuticas..."></textarea>
                </div>

                <div class="form-group">
                    <label class="font-weight-bold text-muted">
                        <i class="fas fa-clipboard mr-1"></i> Observaciones Adicionales / Plan de Seguimiento:
                    </label>
                    <textarea name="observaciones" class="form-control" rows="2" placeholder="Pruebas complementarias solicitadas, fecha estimada de revisión, precauciones..."></textarea>
                </div>

                <div class="text-right">
                    <button type="submit" class="btn btn-success btn-icon-split shadow">
                        <span class="icon text-white-50"><i class="fas fa-check"></i></span>
                        <span class="text">Guardar y Registrar Informe Clínico</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
    <% } %>

    <% } %>

</div>

<%@ include file="components/body2.jsp"%>
