<%@ page import="java.util.List" %>
<%@ page import="Logica.Cita" %>
<%@ page import="Logica.SecurityUtils" %>
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
    String csrfToken = SecurityUtils.obtenerOGenerarTokenCsrf(request.getSession());
%>

<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Histórico de Citas</h1>
            <p class="mb-0 text-gray-600">Consulta y gestión de citas médicas programadas</p>
        </div>
        <div>
            <a href="calendario-citas.jsp" class="btn btn-info shadow-sm mr-2">
                <i class="fas fa-calendar-alt fa-sm text-white-50 mr-1"></i> Ver en Calendario
            </a>
            <a href="SvNuevaCita" class="btn btn-primary shadow-sm">
                <i class="fas fa-calendar-plus fa-sm text-white-50 mr-1"></i> Nueva Cita
            </a>
        </div>
    </div>

    <% 
        String mensajeExito = (String) request.getSession().getAttribute("mensajeExito");
        String errorCita = (String) request.getSession().getAttribute("errorCita");
        if (mensajeExito != null) {
            request.getSession().removeAttribute("mensajeExito");
    %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle mr-2"></i><%=SecurityUtils.escapeHtml(mensajeExito)%>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    <% } %>

    <% if (errorCita != null) { 
            request.getSession().removeAttribute("errorCita");
    %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle mr-2"></i><%=SecurityUtils.escapeHtml(errorCita)%>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    <% } %>

    <!-- Tabla Histórico de Citas -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Listado de Citas</h6>
            <div>
                <a href="calendario-citas.jsp" class="btn btn-sm btn-outline-info mr-2">
                    <i class="far fa-calendar mr-1"></i> Calendario
                </a>
                <a href="SvNuevaCita" class="btn btn-sm btn-success">
                    <i class="fas fa-plus mr-1"></i> Agendar Cita
                </a>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
                    <thead class="thead-light">
                        <tr>
                            <th># ID</th>
                            <th>Fecha</th>
                            <th>Hora Cita</th>
                            <th>Paciente</th>
                            <th>Médico Asignado</th>
                            <th>Horario Laboral Médico</th>
                            <th>Motivo</th>
                            <th style="width: 1%; white-space: nowrap;">Historial / Acción</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th># ID</th>
                            <th>Fecha</th>
                            <th>Hora Cita</th>
                            <th>Paciente</th>
                            <th>Médico Asignado</th>
                            <th>Horario Laboral Médico</th>
                            <th>Motivo</th>
                            <th style="width: 1%; white-space: nowrap;">Historial / Acción</th>
                        </tr>
                    </tfoot>

                    <% 
                        List<Cita> listaCitas = (List<Cita>) request.getSession().getAttribute("listaCitas");
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    %>
                    <tbody>
                    <% if (listaCitas != null && !listaCitas.isEmpty()) {
                           for (Cita c : listaCitas) { 
                               String pacienteStr = (c.getPaciente() != null) 
                                       ? c.getPaciente().getNombre() + " " + c.getPaciente().getApellido() + " (" + c.getPaciente().getDni() + ")" 
                                       : "Sin paciente asignado";
                               String medicoStr = (c.getCitaMedico() != null)
                                       ? "Dr./Dra. " + c.getCitaMedico().getNombre() + " " + c.getCitaMedico().getApellido() + " - " + c.getCitaMedico().getEspecialidad()
                                       : "Sin médico asignado";
                               String horarioMedico = (c.getCitaMedico() != null && c.getCitaMedico().getHorarioMedico() != null)
                                       ? c.getCitaMedico().getHorarioMedico().getHora_inicio() + " a " + c.getCitaMedico().getHorarioMedico().getHora_fin()
                                       : "Sin horario";
                    %>
                        <tr>
                            <td><span class="badge badge-secondary">#<%=c.getId_cita()%></span></td>
                            <td><strong><%=c.getFecha_cita() != null ? sdf.format(c.getFecha_cita()) : "-"%></strong></td>
                            <td><span class="badge badge-info font-weight-bold" style="font-size: 0.95rem;"><%=c.getHora_cita() != null ? c.getHora_cita() : "-"%></span></td>
                            <td>
                                <% if (c.getPaciente() != null) { %>
                                    <a href="SvHistorialPaciente?id=<%=c.getPaciente().getId_persona()%>" class="text-primary font-weight-bold" title="Ver Historial Clínico">
                                        <%=SecurityUtils.escapeHtml(pacienteStr)%>
                                    </a>
                                <% } else { %>
                                    <%=SecurityUtils.escapeHtml(pacienteStr)%>
                                <% } %>
                            </td>
                            <td><%=SecurityUtils.escapeHtml(medicoStr)%></td>
                            <td><span class="badge badge-light border"><i class="far fa-clock mr-1 text-primary"></i><%=SecurityUtils.escapeHtml(horarioMedico)%></span></td>
                            <td><%=SecurityUtils.escapeHtml(c.getMotivo() != null ? c.getMotivo() : "-")%></td>
                            <td style="white-space: nowrap;">
                                <% if (c.getPaciente() != null) { %>
                                <a href="SvHistorialPaciente?id=<%=c.getPaciente().getId_persona()%>" class="btn btn-sm btn-info mr-1" title="Historial Clínico">
                                    <i class="fas fa-file-medical-alt"></i>
                                </a>
                                <a href="SvGenerarInforme?id=<%=c.getPaciente().getId_persona()%>" class="btn btn-sm btn-success mr-1" title="Generar Informe Médico">
                                    <i class="fas fa-plus"></i>
                                </a>
                                <% } %>
                                <form action="SvEliminarCita" method="POST" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="<%=csrfToken%>">
                                    <input type="hidden" name="id" value="<%=c.getId_cita()%>">
                                    <button type="submit" class="btn btn-sm btn-danger" title="Cancelar cita">
                                        <i class="fas fa-trash-alt mr-1"></i> Cancelar
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%     }
                       } else { %>
                        <tr>
                            <td colspan="8" class="text-center py-4 text-muted">
                                <i class="fas fa-calendar-times fa-2x mb-2 d-block text-gray-400"></i>
                                No hay citas registradas en el sistema. <a href="SvNuevaCita">¡Agendar la primera cita!</a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<%@ include file="components/body2.jsp"%>
