<%@ page import="java.util.List" %>
<%@ page import="Logica.Paciente" %>
<%@ page import="Logica.Medico" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 27/11/2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<%
    Paciente pacSeleccionado = (Paciente) request.getAttribute("pacienteSeleccionado");
    List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
    List<Medico> listaMedicos = (List<Medico>) request.getAttribute("listaMedicos");
    Medico medicoSesion = (Medico) request.getAttribute("medicoSesion");
%>

<div class="container-fluid">

    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Generar Informe Médico</h1>
            <p class="mb-0 text-gray-600">Registro facultativo de diagnóstico, tratamiento e historia clínica</p>
        </div>
        <a href="SvPacientes" class="btn btn-secondary shadow-sm">
            <i class="fas fa-arrow-left fa-sm mr-1"></i> Volver a Pacientes
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow mb-4 border-left-success">
                <div class="card-header py-3 bg-white">
                    <h6 class="m-0 font-weight-bold text-success">
                        <i class="fas fa-file-medical mr-1"></i> Datos del Informe Clínico
                    </h6>
                </div>
                <div class="card-body">
                    <form action="SvGenerarInforme" method="post">
                        
                        <div class="form-row">
                            <!-- Selector o Paciente fijo -->
                            <div class="form-group col-md-6">
                                <label class="font-weight-bold text-gray-900">
                                    <i class="fas fa-user mr-1 text-primary"></i> Paciente:
                                </label>
                                <% if (pacSeleccionado != null) { %>
                                    <input type="hidden" name="id_paciente" value="<%=pacSeleccionado.getId_persona()%>">
                                    <input type="text" class="form-control bg-light" readonly
                                           value="<%=pacSeleccionado.getNombre()%> <%=pacSeleccionado.getApellido()%> (DNI: <%=pacSeleccionado.getDni()%>)">
                                <% } else { %>
                                    <select name="id_paciente" class="form-control" required>
                                        <option value="" disabled selected>-- Seleccione un Paciente --</option>
                                        <% if (listaPacientes != null) {
                                               for (Paciente p : listaPacientes) { %>
                                            <option value="<%=p.getId_persona()%>">
                                                <%=p.getNombre()%> <%=p.getApellido()%> (DNI: <%=p.getDni()%>)
                                            </option>
                                        <%     }
                                           } %>
                                    </select>
                                <% } %>
                            </div>

                            <!-- Médico Responsable -->
                            <div class="form-group col-md-6">
                                <label class="font-weight-bold text-gray-900">
                                    <i class="fas fa-user-md mr-1 text-success"></i> Médico Responsable:
                                </label>
                                <% if (rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
                                    <% if (medicoSesion != null) { %>
                                        <input type="hidden" name="id_medico" value="<%=medicoSesion.getId_persona()%>">
                                        <input type="text" class="form-control bg-light" readonly
                                               value="Dr./Dra. <%=medicoSesion.getNombre()%> <%=medicoSesion.getApellido()%> - <%=medicoSesion.getEspecialidad()%>">
                                    <% } else { %>
                                        <select name="id_medico" class="form-control" required>
                                            <option value="" disabled selected>Seleccione su perfil médico...</option>
                                            <% if (listaMedicos != null) {
                                                   for (Medico m : listaMedicos) { %>
                                                <option value="<%=m.getId_persona()%>">Dr./Dra. <%=m.getNombre()%> <%=m.getApellido()%> (<%=m.getEspecialidad()%>)</option>
                                            <%     }
                                               } %>
                                        </select>
                                    <% } %>
                                <% } else { %>
                                    <select name="id_medico" class="form-control" required>
                                        <option value="" disabled selected>-- Seleccionar Médico Firmante --</option>
                                        <% if (listaMedicos != null) {
                                               for (Medico m : listaMedicos) { %>
                                            <option value="<%=m.getId_persona()%>">
                                                Dr./Dra. <%=m.getNombre()%> <%=m.getApellido()%> (<%=m.getEspecialidad()%>)
                                            </option>
                                        <%     }
                                           } %>
                                    </select>
                                <% } %>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold text-gray-900">Motivo de Consulta / Anamnesis:</label>
                            <input type="text" name="motivo" class="form-control" placeholder="Ej: Dolor torácico atípico, revisión postoperatoria..." required>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold text-danger">
                                <i class="fas fa-stethoscope mr-1"></i> Diagnóstico Clínico:
                            </label>
                            <textarea name="diagnostico" class="form-control" rows="4" placeholder="Exploración física, constantes, juicio diagnóstico..." required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold text-info">
                                <i class="fas fa-pills mr-1"></i> Tratamiento y Medicación Prescrita:
                            </label>
                            <textarea name="tratamiento" class="form-control" rows="4" placeholder="Tratamiento prescrito, medicamentos, dosis, pautas horarias..."></textarea>
                        </div>

                        <div class="form-group">
                            <label class="font-weight-bold text-muted">
                                <i class="fas fa-clipboard-check mr-1"></i> Observaciones Adicionales y Recomendaciones:
                            </label>
                            <textarea name="observaciones" class="form-control" rows="3" placeholder="Pautas higiénico-dietéticas, signos de alarma, fecha recomendada de revisión..."></textarea>
                        </div>

                        <hr>

                        <div class="d-flex justify-content-between align-items-center">
                            <a href="SvPacientes" class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-success px-4 py-2 shadow">
                                <i class="fas fa-check-circle mr-1"></i> Guardar Informe Médico
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>

</div>

<%@ include file="components/body2.jsp"%>
