<%@ page import="java.util.List" %>
<%@ page import="Logica.Medico" %>
<%@ page import="Logica.Paciente" %>
<%@ page import="Logica.Controller" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 27/11/2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<%
    Controller cont = new Controller();

    String filtroEsp = request.getParameter("filtroEsp");
    String filtroMed = request.getParameter("filtroMed");
    String filtroPac = request.getParameter("filtroPac");
    if (filtroEsp != null) filtroEsp = filtroEsp.trim();
    if (filtroMed != null) filtroMed = filtroMed.trim();
    if (filtroPac != null) filtroPac = filtroPac.trim();

    String paramFecha = request.getParameter("fecha_cita");
    String paramHora = request.getParameter("hora_cita");
    String paramMotivo = request.getParameter("motivo");

    boolean hayFiltroMed = (filtroMed != null && !filtroMed.isEmpty()) || (filtroEsp != null && !filtroEsp.isEmpty() && !"todas".equalsIgnoreCase(filtroEsp));
    boolean hayFiltroPac = (filtroPac != null && !filtroPac.isEmpty());
    boolean hayFiltroActivo = hayFiltroMed || hayFiltroPac;

    List<Medico> listaMedicos = cont.buscarMedicos(filtroMed, filtroEsp);
    List<Paciente> listaPacientes = cont.buscarPacientes(filtroPac);
    List<String> especialidades = cont.getEspecialidades();

    String errorCita = (String) request.getSession().getAttribute("errorCita");
    if (errorCita != null) {
        request.getSession().removeAttribute("errorCita");
    }
%>

<div class="container">
    <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
            <div class="row justify-content-center">
                <div class="col-lg-9">
                    <div class="p-5">

                        <div class="text-center mb-4">
                            <h1 class="h4 text-gray-900 font-weight-bold">
                                <i class="fas fa-calendar-check text-primary mr-2"></i>Agendar Nueva Cita
                            </h1>
                            <p class="text-gray-600 small">Búsqueda de facultativos por especialidad y paciente para asignación horaria</p>
                        </div>

                        <% if (errorCita != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                                <i class="fas fa-exclamation-triangle mr-2"></i>
                                <strong>No se pudo agendar la cita:</strong> <%=errorCita%>
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                        <% } %>

                        <!-- Filtro de Búsqueda de Médico y Paciente (HTML nativo sin JS) -->
                        <div class="card shadow-sm mb-4 border-left-info">
                            <div class="card-header py-2 bg-white d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold text-info">
                                    <i class="fas fa-filter mr-1"></i> Filtrar Médicos por Especialidad / Nombre y Pacientes
                                </h6>
                                <% if (hayFiltroActivo) { %>
                                    <a href="alta-cita.jsp" class="btn btn-sm btn-outline-secondary">
                                        <i class="fas fa-times mr-1"></i> Quitar Filtros
                                    </a>
                                <% } %>
                            </div>
                            <div class="card-body py-3">
                                <form action="alta-cita.jsp" method="GET" class="form-row align-items-end">
                                    
                                    <!-- Especialidad -->
                                    <div class="col-md-4 mb-2">
                                        <label class="small font-weight-bold text-gray-700">1. Filtrar por Especialidad Médica:</label>
                                        <select name="filtroEsp" class="form-control form-control-sm">
                                            <option value="todas">-- Todas las Especialidades --</option>
                                            <% if (especialidades != null) {
                                                   for (String esp : especialidades) {
                                                       boolean sel = (filtroEsp != null && filtroEsp.equalsIgnoreCase(esp));
                                            %>
                                                <option value="<%=esp%>" <%=sel ? "selected" : ""%>><%=esp%></option>
                                            <%     }
                                               } %>
                                        </select>
                                    </div>

                                    <!-- Nombre Médico -->
                                    <div class="col-md-4 mb-2">
                                        <label class="small font-weight-bold text-gray-700">2. Buscar Médico por Nombre:</label>
                                        <input type="text" name="filtroMed" class="form-control form-control-sm" 
                                               placeholder="Nombre o apellido del doctor..." 
                                               value="<%=filtroMed != null ? filtroMed : ""%>">
                                    </div>

                                    <!-- Nombre Paciente -->
                                    <div class="col-md-4 mb-2">
                                        <label class="small font-weight-bold text-gray-700">3. Buscar Paciente por Nombre/DNI:</label>
                                        <input type="text" name="filtroPac" class="form-control form-control-sm" 
                                               placeholder="Nombre o DNI del paciente..." 
                                               value="<%=filtroPac != null ? filtroPac : ""%>">
                                    </div>

                                    <!-- Mantener datos previos de fecha/hora si se habían introducido -->
                                    <input type="hidden" name="fecha_cita" value="<%=paramFecha != null ? paramFecha : ""%>">
                                    <input type="hidden" name="hora_cita" value="<%=paramHora != null ? paramHora : ""%>">
                                    <input type="hidden" name="motivo" value="<%=paramMotivo != null ? paramMotivo : ""%>">

                                    <div class="col-12 mt-2 d-flex justify-content-between align-items-center">
                                        <span class="small text-muted">
                                            <% if (hayFiltroActivo) { %>
                                                Filtro activo: <strong><%=listaMedicos != null ? listaMedicos.size() : 0%> médico(s)</strong> y 
                                                <strong><%=listaPacientes != null ? listaPacientes.size() : 0%> paciente(s)</strong> disponibles.
                                            <% } else { %>
                                                Filtra los desplegables de abajo por nombre o especialidad médica.
                                            <% } %>
                                        </span>
                                        <button type="submit" class="btn btn-sm btn-info shadow-sm">
                                            <i class="fas fa-search mr-1"></i> Aplicar Filtros
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Formulario de Agendar Cita -->
                        <form action="SvCitas" method="POST" id="formCita" class="user">

                            <!-- Selección de Médico -->
                            <div class="form-group">
                                <label class="font-weight-bold text-gray-800">
                                    1. Seleccionar Médico 
                                    <small class="text-muted">(<%=listaMedicos != null ? listaMedicos.size() : 0%> disponibles)</small>:
                                </label>
                                <select name="id_medico" id="selectMedico" class="form-control" required style="height: 48px; border-radius: 10rem;">
                                    <option value="" disabled <%=listaMedicos == null || listaMedicos.size() != 1 ? "selected" : ""%>>-- Elige un médico disponible --</option>
                                    <% if (listaMedicos != null) {
                                           for (Medico med : listaMedicos) {
                                               boolean autoSelect = (listaMedicos.size() == 1);
                                               String horaIni = (med.getHorarioMedico() != null && med.getHorarioMedico().getHora_inicio() != null) 
                                                       ? med.getHorarioMedico().getHora_inicio() : "";
                                               String horaFin = (med.getHorarioMedico() != null && med.getHorarioMedico().getHora_fin() != null) 
                                                       ? med.getHorarioMedico().getHora_fin() : "";
                                               String textoHorario = (!horaIni.isEmpty() && !horaFin.isEmpty()) 
                                                       ? (horaIni + " - " + horaFin) : "Sin horario definido";
                                    %>
                                        <option value="<%=med.getId_persona()%>" 
                                                <%=autoSelect ? "selected" : ""%>
                                                data-inicio="<%=horaIni%>" 
                                                data-fin="<%=horaFin%>"
                                                data-nombre="Dr./Dra. <%=med.getNombre()%> <%=med.getApellido()%>">
                                            Dr./Dra. <%=med.getNombre()%> <%=med.getApellido()%> - [<%=med.getEspecialidad() != null ? med.getEspecialidad() : "General"%>] [Horario: <%=textoHorario%>]
                                        </option>
                                    <%     }
                                       } %>
                                </select>
                            </div>

                            <!-- Cartel informativo del horario del médico seleccionado -->
                            <div id="infoHorario" class="alert alert-info py-2 d-none" role="alert">
                                <i class="fas fa-clock mr-1"></i>
                                <span id="textoInfoHorario"></span>
                            </div>

                            <!-- Fecha y Hora de la Cita -->
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="font-weight-bold text-gray-800">2. Fecha de la Cita:</label>
                                    <input type="date" class="form-control" id="fechaCita" name="fecha_cita" 
                                           value="<%=paramFecha != null ? paramFecha : ""%>"
                                           required style="height: 48px; border-radius: 10rem;">
                                </div>
                                <div class="col-sm-6">
                                    <label class="font-weight-bold text-gray-800">3. Hora de la Cita:</label>
                                    <input type="time" class="form-control" id="horaCita" name="hora_cita" 
                                           value="<%=paramHora != null ? paramHora : ""%>"
                                           required style="height: 48px; border-radius: 10rem;">
                                    <small id="horaFeedback" class="form-text text-danger font-weight-bold d-none"></small>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- Selección o Registro de Paciente -->
                            <div class="form-group">
                                <label class="font-weight-bold text-gray-800">
                                    4. Paciente 
                                    <small class="text-muted">(<%=listaPacientes != null ? listaPacientes.size() : 0%> disponibles)</small>:
                                </label>
                                <select name="id_paciente" id="selectPaciente" class="form-control" required style="height: 48px; border-radius: 10rem;">
                                    <option value="" disabled <%=listaPacientes == null || listaPacientes.size() != 1 ? "selected" : ""%>>-- Elige un paciente --</option>
                                    <% if (listaPacientes != null && !listaPacientes.isEmpty()) {
                                           for (Paciente pac : listaPacientes) { 
                                               boolean autoSelectPac = (listaPacientes.size() == 1);
                                    %>
                                        <option value="<%=pac.getId_persona()%>" <%=autoSelectPac ? "selected" : ""%>>
                                            <%=pac.getNombre()%> <%=pac.getApellido()%> (DNI: <%=pac.getDni()%>) [Seguro: <%=pac.getSeguro_medico() != null ? pac.getSeguro_medico() : "Particular"%>]<%=pac.esMenorDeEdad() ? " [MENOR DE EDAD" + (pac.getResponsable() != null ? " - Tutor: " + pac.getResponsable().getNombre() + " " + pac.getResponsable().getApellido() : " - Sin Tutor") + "]" : ""%>
                                        </option>
                                    <%     }
                                       } %>
                                    <option value="nuevo" class="font-weight-bold text-primary">+ [Registrar un nuevo paciente para esta cita]</option>
                                </select>
                            </div>

                            <!-- Registro de nuevo paciente sin JavaScript (HTML5 nativo) -->
                            <details class="card bg-light p-3 mb-3 border-left-primary">
                                <summary class="font-weight-bold text-primary" style="cursor: pointer;">
                                    <i class="fas fa-user-plus mr-1"></i> ¿El paciente no está en la lista? Haz clic aquí para registrarlo
                                </summary>
                                <div class="mt-3">
                                    <p class="small text-muted mb-2">Si completas estos campos, se registrará el nuevo paciente automáticamente:</p>
                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2">
                                            <input type="text" class="form-control" name="pac_nombre" id="pac_nombre" placeholder="Nombre del nuevo paciente" style="border-radius: 10rem;">
                                        </div>
                                        <div class="col-sm-6">
                                            <input type="text" class="form-control" name="pac_apellido" id="pac_apellido" placeholder="Apellidos" style="border-radius: 10rem;">
                                        </div>
                                    </div>
                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2">
                                            <input type="text" class="form-control" name="pac_dni" id="pac_dni" placeholder="DNI del paciente" style="border-radius: 10rem;">
                                        </div>
                                        <div class="col-sm-6">
                                            <input type="tel" class="form-control" name="pac_telefono" id="pac_telefono" placeholder="Teléfono" style="border-radius: 10rem;">
                                        </div>
                                    </div>
                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2">
                                            <label class="small text-muted mb-0 ml-2">Fecha Nacimiento (calcula minoría de edad):</label>
                                            <input type="date" class="form-control" name="pac_fecha_nac" style="border-radius: 10rem;">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="small text-muted mb-0 ml-2">Seguro Médico:</label>
                                            <input type="text" class="form-control" name="pac_seguro" placeholder="Ej: Sanitas / Particular" style="border-radius: 10rem;">
                                        </div>
                                    </div>
                                    <div class="bg-white p-2 rounded border mb-1">
                                        <small class="font-weight-bold text-warning d-block mb-1">
                                            <i class="fas fa-user-shield mr-1"></i> Si el paciente es menor de edad, indica su tutor legal:
                                        </small>
                                        <div class="form-row">
                                            <div class="col-md-4 mb-1">
                                                <input type="text" class="form-control form-control-sm" name="resp_nombre" placeholder="Nombre y Apellidos Tutor">
                                            </div>
                                            <div class="col-md-4 mb-1">
                                                <input type="text" class="form-control form-control-sm" name="resp_dni" placeholder="DNI del Tutor">
                                            </div>
                                            <div class="col-md-4 mb-1">
                                                <input type="tel" class="form-control form-control-sm" name="resp_telefono" placeholder="Teléfono Tutor">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </details>

                            <!-- Motivo de la Cita -->
                            <div class="form-group">
                                <label class="font-weight-bold text-gray-800">5. Motivo de la Consulta:</label>
                                <textarea name="motivo" class="form-control" rows="3" placeholder="Describe brevemente el motivo o síntoma de la consulta médica..." required style="border-radius: 1rem;"><%=paramMotivo != null ? paramMotivo : ""%></textarea>
                            </div>

                            <!-- Botones de Acción -->
                            <div class="row mt-4">
                                <div class="col-sm-6 mb-2">
                                    <a href="SvCitas" class="btn btn-secondary btn-user btn-block">
                                        <i class="fas fa-arrow-left mr-1"></i> Volver al Histórico
                                    </a>
                                </div>
                                <div class="col-sm-6">
                                    <button type="submit" id="btnAgendar" class="btn btn-primary btn-user btn-block font-weight-bold">
                                        <i class="fas fa-check-circle mr-1"></i> Confirmar Cita
                                    </button>
                                </div>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<%@ include file="components/body2.jsp"%>
