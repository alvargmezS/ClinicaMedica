<%@ page import="java.util.List" %>
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

<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Informes Médicos Clínicos</h1>
            <p class="mb-0 text-gray-600">Registro histórico de informes médicos, diagnósticos y tratamientos emitidos</p>
        </div>
        <div>
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
            <a href="SvGenerarInforme" class="btn btn-success shadow-sm mr-2">
                <i class="fas fa-file-medical fa-sm mr-1"></i> Redactar Nuevo Informe
            </a>
            <% } %>
            <a href="SvPacientes" class="btn btn-primary shadow-sm">
                <i class="fas fa-users fa-sm text-white-50 mr-1"></i> Ver Pacientes
            </a>
        </div>
    </div>

    <!-- DataTales Informes -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Histórico Global de Informes Clínicos</h6>
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
            <a href="SvGenerarInforme" class="btn btn-sm btn-success">
                <i class="fas fa-plus mr-1"></i> Nuevo Informe
            </a>
            <% } %>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
                    <thead class="thead-light">
                        <tr>
                            <th>Id</th>
                            <th>Fecha</th>
                            <th>Paciente</th>
                            <th>DNI Paciente</th>
                            <th>Médico Facultativo</th>
                            <th>Especialidad</th>
                            <th>Motivo Consulta</th>
                            <th>Diagnóstico (Extracto)</th>
                            <th style="white-space: nowrap;">Acción</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Id</th>
                            <th>Fecha</th>
                            <th>Paciente</th>
                            <th>DNI Paciente</th>
                            <th>Médico Facultativo</th>
                            <th>Especialidad</th>
                            <th>Motivo Consulta</th>
                            <th>Diagnóstico (Extracto)</th>
                            <th style="white-space: nowrap;">Acción</th>
                        </tr>
                    </tfoot>

                    <% 
                        List<InformeMedico> listaInformes = (List<InformeMedico>) request.getSession().getAttribute("listaInformes"); 
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    %>
                    <tbody>

                    <% if (listaInformes != null && !listaInformes.isEmpty()) {
                           for (InformeMedico inf : listaInformes) { 
                               Paciente p = inf.getPaciente();
                               Medico m = inf.getMedico();
                               String diag = inf.getDiagnostico();
                               if (diag != null && diag.length() > 60) {
                                   diag = diag.substring(0, 60) + "...";
                               }
                    %>
                        <tr>
                            <td><span class="badge badge-secondary">#<%=inf.getId_informe()%></span></td>
                            <td><%=inf.getFecha_informe() != null ? sdf.format(inf.getFecha_informe()) : "-"%></td>
                            <td>
                                <% if (p != null) { %>
                                    <a href="SvHistorialPaciente?id=<%=p.getId_persona()%>" class="text-primary font-weight-bold">
                                        <%=p.getNombre()%> <%=p.getApellido()%>
                                    </a>
                                <% } else { %>
                                    <span class="text-muted">Paciente eliminado</span>
                                <% } %>
                            </td>
                            <td><%=p != null && p.getDni() != null ? p.getDni() : "-"%></td>
                            <td>
                                <%=m != null ? ("Dr./Dra. " + m.getNombre() + " " + m.getApellido()) : "<span class='text-muted'>No asignado</span>"%>
                            </td>
                            <td><%=m != null && m.getEspecialidad() != null ? m.getEspecialidad() : "-"%></td>
                            <td><strong><%=inf.getMotivo_consulta() != null ? inf.getMotivo_consulta() : "-"%></strong></td>
                            <td><%=diag != null ? diag : "-"%></td>
                            <td style="white-space: nowrap;">
                                <a href="SvVerInforme?id=<%=inf.getId_informe()%>" class="btn btn-sm btn-outline-primary mr-1" title="Ver e Imprimir">
                                    <i class="fas fa-print mr-1"></i> Ver
                                </a>
                                <a href="SvDescargarInformePdf?id=<%=inf.getId_informe()%>" class="btn btn-sm btn-outline-danger mr-1" title="Descargar en PDF">
                                    <i class="fas fa-file-pdf mr-1"></i> PDF
                                </a>
                                <% if (p != null) { %>
                                <a href="SvHistorialPaciente?id=<%=p.getId_persona()%>" class="btn btn-sm btn-info" title="Ver Historial Clínico">
                                    <i class="fas fa-file-medical-alt mr-1"></i> Historial
                                </a>
                                <% } %>
                            </td>
                        </tr>
                    <%     }
                       } else { %>
                        <tr>
                            <td colspan="9" class="text-center py-4 text-muted">
                                <i class="fas fa-clipboard-list fa-2x mb-2 d-block text-gray-400"></i>
                                No constan informes médicos registrados. 
                                <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
                                    <a href="SvGenerarInforme">¡Generar el primer informe!</a>
                                <% } %>
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
