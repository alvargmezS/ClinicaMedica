<%@ page import="java.util.List" %>
<%@ page import="Logica.Cita" %>
<%@ page import="Logica.Medico" %>
<%@ page import="Logica.Paciente" %>
<%@ page import="Logica.Controller" %>
<%@ page import="Logica.SecurityUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.LocalDate" %>
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

    // Asegurar que las listas estén disponibles
    List<Cita> listaCitas = (List<Cita>) request.getSession().getAttribute("listaCitas");
    List<Medico> listaMedicos = (List<Medico>) request.getSession().getAttribute("listaMedicos");
    List<Paciente> listaPacientes = (List<Paciente>) request.getSession().getAttribute("listaPacientes");

    if (listaCitas == null) listaCitas = cont.getCitas();
    if (listaMedicos == null) listaMedicos = cont.getMedicos();
    if (listaPacientes == null) listaPacientes = cont.getPacientes();

    // Comprobar si el usuario conectado es Médico
    Medico medicoLogueado = cont.getMedicoPorUsuario(usuario);
    boolean esUsuarioMedico = (medicoLogueado != null);
    int idMedicoLogueado = esUsuarioMedico ? medicoLogueado.getId_persona() : 0;

    // Gestión del Mes y Año (Server-Side sin JavaScript)
    LocalDate fechaHoy = LocalDate.now();
    int anioActual = fechaHoy.getYear();
    int mesActual = fechaHoy.getMonthValue();

    String paramMes = request.getParameter("mes");
    String paramAnio = request.getParameter("anio");

    int mes = mesActual;
    int anio = anioActual;
    try {
        if (paramMes != null && !paramMes.trim().isEmpty()) mes = Integer.parseInt(paramMes.trim());
        if (paramAnio != null && !paramAnio.trim().isEmpty()) anio = Integer.parseInt(paramAnio.trim());
    } catch (NumberFormatException ignored) {}

    // Normalizar mes y año al navegar
    if (mes < 1) { mes = 12; anio--; }
    if (mes > 12) { mes = 1; anio++; }

    YearMonth ym = YearMonth.of(anio, mes);
    int totalDiasMes = ym.lengthOfMonth();
    int diaSemanaPrimerDia = ym.atDay(1).getDayOfWeek().getValue(); // 1 = Lunes ... 7 = Domingo

    YearMonth ymPrev = ym.minusMonths(1);
    YearMonth ymNext = ym.plusMonths(1);

    String[] nombresMeses = {
        "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
        "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    };
    String nombreMes = nombresMeses[mes - 1];

    // Filtros de Médico y Paciente (Procesados nativamente por el servidor)
    String filtroMedico = request.getParameter("filtroMedico");
    String filtroPaciente = request.getParameter("filtroPaciente");

    if (filtroMedico == null || filtroMedico.trim().isEmpty()) {
        filtroMedico = esUsuarioMedico ? String.valueOf(idMedicoLogueado) : "todos";
    }
    if (filtroPaciente == null || filtroPaciente.trim().isEmpty()) {
        filtroPaciente = "todos";
    }

    String filtroAgenda = request.getParameter("filtroAgenda");
    if (filtroAgenda == null || filtroAgenda.trim().isEmpty()) {
        filtroAgenda = esUsuarioMedico ? "mis_citas" : "todas";
    }

    SimpleDateFormat sdfFecha = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
%>

<style>
    .calendar-table {
        table-layout: fixed;
        width: 100%;
    }
    .calendar-cell {
        height: 130px;
        vertical-align: top !important;
        padding: 6px !important;
        background-color: #ffffff;
    }
    .calendar-cell.today {
        background-color: rgba(78, 115, 223, 0.08) !important;
        border: 2px solid #4e73df !important;
    }
    .calendar-cell.other-month {
        background-color: #f8f9fc !important;
    }
    .cita-card {
        border-left: 3px solid #4e73df;
        background-color: #ffffff;
        font-size: 0.75rem;
        line-height: 1.25;
        border-radius: 4px;
        transition: box-shadow 0.2s;
    }
    .cita-card:hover {
        box-shadow: 0 2px 5px rgba(0,0,0,0.15);
    }
</style>

<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">
                <i class="far fa-calendar-alt text-primary mr-2"></i>Agenda y Calendario de Citas
            </h1>
            <p class="mb-0 text-gray-600">Calendario interactivo servidor (HTML puro sin JavaScript) con acceso directo a historiales e informes</p>
        </div>
        <div>
            <a href="#seccionPacientesAgendados" class="btn btn-outline-primary shadow-sm mr-2">
                <i class="fas fa-user-injured fa-sm mr-1"></i> Pacientes Agendados
            </a>
            <a href="SvCitas" class="btn btn-secondary shadow-sm mr-2">
                <i class="fas fa-list fa-sm mr-1"></i> Vista Tabla
            </a>
            <a href="SvNuevaCita" class="btn btn-primary shadow-sm">
                <i class="fas fa-plus fa-sm text-white-50 mr-1"></i> Agendar Cita
            </a>
        </div>
    </div>

    <% if (esUsuarioMedico) { %>
    <div class="alert alert-info border-left-info shadow-sm d-flex justify-content-between align-items-center mb-4">
        <div>
            <i class="fas fa-user-md fa-lg mr-2"></i>
            Bienvenido/a <strong>Dr./Dra. <%=SecurityUtils.escapeHtml(medicoLogueado.getNombre())%> <%=SecurityUtils.escapeHtml(medicoLogueado.getApellido())%></strong> (<%=SecurityUtils.escapeHtml(medicoLogueado.getEspecialidad())%>).
        </div>
        <div>
            <span class="badge badge-primary px-3 py-2">
                Horario: <%=medicoLogueado.getHorarioMedico() != null ? (medicoLogueado.getHorarioMedico().getHora_inicio() + " - " + medicoLogueado.getHorarioMedico().getHora_fin()) : "Sin configurar"%>
            </span>
        </div>
    </div>
    <% } %>

    <!-- Barra de Filtros (HTML Puro) -->
    <form action="calendario-citas.jsp" method="GET" class="card shadow mb-4 border-left-primary">
        <input type="hidden" name="mes" value="<%=mes%>">
        <input type="hidden" name="anio" value="<%=anio%>">

        <div class="card-body py-3">
            <div class="row align-items-end">

                <!-- Filtro Médico -->
                <div class="col-md-4 mb-2 mb-md-0">
                    <label class="small font-weight-bold text-gray-700 mb-1">
                        <i class="fas fa-user-md text-primary mr-1"></i> Filtrar por Médico:
                    </label>
                    <select name="filtroMedico" class="form-control form-control-sm">
                        <option value="todos" <%="todos".equals(filtroMedico) ? "selected" : ""%>>-- Todos los Médicos --</option>
                        <% if (listaMedicos != null) {
                               for (Medico m : listaMedicos) {
                                   String valM = String.valueOf(m.getId_persona());
                                   boolean selM = valM.equals(filtroMedico);
                        %>
                            <option value="<%=valM%>" <%=selM ? "selected" : ""%>>
                                Dr./Dra. <%=SecurityUtils.escapeHtml(m.getNombre())%> <%=SecurityUtils.escapeHtml(m.getApellido())%> (<%=SecurityUtils.escapeHtml(m.getEspecialidad())%>)
                            </option>
                        <%     }
                           } %>
                    </select>
                </div>

                <!-- Filtro Paciente -->
                <div class="col-md-4 mb-2 mb-md-0">
                    <label class="small font-weight-bold text-gray-700 mb-1">
                        <i class="fas fa-user-injured text-success mr-1"></i> Filtrar por Paciente:
                    </label>
                    <select name="filtroPaciente" class="form-control form-control-sm">
                        <option value="todos" <%="todos".equals(filtroPaciente) ? "selected" : ""%>>-- Todos los Pacientes --</option>
                        <% if (listaPacientes != null) {
                               for (Paciente p : listaPacientes) {
                                   String valP = String.valueOf(p.getId_persona());
                                   boolean selP = valP.equals(filtroPaciente);
                        %>
                            <option value="<%=valP%>" <%=selP ? "selected" : ""%>>
                                <%=SecurityUtils.escapeHtml(p.getNombre())%> <%=SecurityUtils.escapeHtml(p.getApellido())%> (DNI: <%=SecurityUtils.escapeHtml(p.getDni())%>)
                            </option>
                        <%     }
                           } %>
                    </select>
                </div>

                <!-- Botones Filtrar y Limpiar -->
                <div class="col-md-4 text-md-right mt-3 mt-md-0">
                    <button type="submit" class="btn btn-primary btn-sm mr-1">
                        <i class="fas fa-filter mr-1"></i> Filtrar Citas
                    </button>
                    <a href="calendario-citas.jsp?mes=<%=mes%>&anio=<%=anio%>&filtroMedico=todos&filtroPaciente=todos" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-sync-alt mr-1"></i> Limpiar Filtros
                    </a>
                </div>

            </div>
        </div>
    </form>

    <!-- Contenedor del Calendario (Renderizado Server-Side) -->
    <div class="card shadow mb-4">
        <!-- Cabecera de Navegación del Mes -->
        <div class="card-header py-3 bg-white d-flex flex-wrap justify-content-between align-items-center">
            <div>
                <a href="calendario-citas.jsp?mes=<%=ymPrev.getMonthValue()%>&anio=<%=ymPrev.getYear()%>&filtroMedico=<%=filtroMedico%>&filtroPaciente=<%=filtroPaciente%>" class="btn btn-sm btn-outline-primary">
                    <i class="fas fa-chevron-left mr-1"></i> <%=nombresMeses[ymPrev.getMonthValue() - 1]%> <%=ymPrev.getYear()%>
                </a>
                <a href="calendario-citas.jsp?mes=<%=mesActual%>&anio=<%=anioActual%>&filtroMedico=<%=filtroMedico%>&filtroPaciente=<%=filtroPaciente%>" class="btn btn-sm btn-secondary ml-1">
                    Mes Actual
                </a>
            </div>
            <h4 class="m-0 font-weight-bold text-primary text-center">
                <i class="far fa-calendar mr-2"></i><%=nombreMes%> de <%=anio%>
            </h4>
            <div>
                <a href="calendario-citas.jsp?mes=<%=ymNext.getMonthValue()%>&anio=<%=ymNext.getYear()%>&filtroMedico=<%=filtroMedico%>&filtroPaciente=<%=filtroPaciente%>" class="btn btn-sm btn-outline-primary">
                    <%=nombresMeses[ymNext.getMonthValue() - 1]%> <%=ymNext.getYear()%> <i class="fas fa-chevron-right ml-1"></i>
                </a>
            </div>
        </div>

        <!-- Tabla del Calendario -->
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered mb-0 calendar-table">
                    <thead class="thead-light text-center">
                        <tr>
                            <th style="width: 14.28%;">Lunes</th>
                            <th style="width: 14.28%;">Martes</th>
                            <th style="width: 14.28%;">Miércoles</th>
                            <th style="width: 14.28%;">Jueves</th>
                            <th style="width: 14.28%;">Viernes</th>
                            <th style="width: 14.28%;" class="text-primary">Sábado</th>
                            <th style="width: 14.28%;" class="text-danger">Domingo</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        int celdaActual = 1;
                        int diaMes = 1;

                        // Se itera hasta completar todas las semanas necesarias
                        while (diaMes <= totalDiasMes) {
                    %>
                        <tr>
                            <%
                                for (int columna = 1; columna <= 7; columna++) {
                                    if (celdaActual < diaSemanaPrimerDia || diaMes > totalDiasMes) {
                            %>
                                        <td class="calendar-cell other-month text-muted small">
                                            &nbsp;
                                        </td>
                            <%
                                    } else {
                                        String fechaDiaIso = String.format("%04d-%02d-%02d", anio, mes, diaMes);
                                        boolean esHoy = (fechaHoy.getYear() == anio && fechaHoy.getMonthValue() == mes && fechaHoy.getDayOfMonth() == diaMes);
                            %>
                                        <td class="calendar-cell <%=esHoy ? "today" : ""%>">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="badge <%=esHoy ? "badge-primary" : "badge-light text-dark"%> font-weight-bold" style="font-size: 0.95rem;">
                                                    <%=diaMes%>
                                                </span>
                                                <a href="SvNuevaCita?fecha=<%=fechaDiaIso%>" class="btn btn-xs btn-outline-primary py-0 px-1" title="Agendar cita para el <%=diaMes%> de <%=nombreMes%>">
                                                    <i class="fas fa-plus"></i>
                                                </a>
                                            </div>

                                            <!-- Renderizado de las citas correspondientes a este día -->
                                            <div style="max-height: 95px; overflow-y: auto;">
                                            <%
                                                if (listaCitas != null) {
                                                    for (Cita c : listaCitas) {
                                                        if (c.getFecha_cita() == null) continue;
                                                        String fechaCita = sdfFecha.format(c.getFecha_cita());
                                                        if (!fechaDiaIso.equals(fechaCita)) continue;

                                                        // Aplicar filtros de médico y paciente
                                                        if (!"todos".equals(filtroMedico)) {
                                                            if (c.getCitaMedico() == null || !String.valueOf(c.getCitaMedico().getId_persona()).equals(filtroMedico)) {
                                                                continue;
                                                            }
                                                        }
                                                        if (!"todos".equals(filtroPaciente)) {
                                                            if (c.getPaciente() == null || !String.valueOf(c.getPaciente().getId_persona()).equals(filtroPaciente)) {
                                                                continue;
                                                            }
                                                        }

                                                        Paciente p = c.getPaciente();
                                                        Medico m = c.getCitaMedico();
                                            %>
                                                <div class="cita-card p-1 mb-1 border shadow-sm">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <span class="badge badge-info font-weight-bold">
                                                            <i class="far fa-clock mr-1"></i><%=c.getHora_cita() != null ? SecurityUtils.escapeHtml(c.getHora_cita()) : "--:--"%>
                                                        </span>
                                                        <form action="SvEliminarCita" method="POST" style="display:inline;" class="mb-0">
                                                            <input type="hidden" name="csrfToken" value="<%=SecurityUtils.obtenerOGenerarTokenCsrf(request.getSession())%>">
                                                            <input type="hidden" name="id" value="<%=c.getId_cita()%>">
                                                            <input type="hidden" name="origen" value="calendario">
                                                            <button type="submit" class="text-danger border-0 bg-transparent p-0" title="Cancelar cita">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </form>
                                                    </div>

                                                    <% if (p != null) { %>
                                                        <div class="font-weight-bold text-dark text-truncate mt-1">
                                                            <i class="fas fa-user-injured text-success mr-1"></i><%=SecurityUtils.escapeHtml(p.getNombre())%> <%=SecurityUtils.escapeHtml(p.getApellido())%>
                                                        </div>
                                                    <% } %>

                                                    <% if (m != null) { %>
                                                        <div class="text-muted text-truncate small">
                                                            <i class="fas fa-user-md text-primary mr-1"></i>Dr. <%=SecurityUtils.escapeHtml(m.getApellido())%>
                                                        </div>
                                                    <% } %>

                                                    <% if (c.getMotivo() != null && !c.getMotivo().trim().isEmpty()) { %>
                                                        <div class="text-gray-600 text-truncate font-italic small">
                                                            <%=SecurityUtils.escapeHtml(c.getMotivo())%>
                                                        </div>
                                                    <% } %>

                                                    <% if (p != null) { %>
                                                        <div class="mt-1 pt-1 border-top d-flex justify-content-between">
                                                            <a href="SvHistorialPaciente?id=<%=p.getId_persona()%>" class="text-info font-weight-bold" title="Historial Clínico">
                                                                <i class="fas fa-file-medical-alt"></i> Historial
                                                            </a>
                                                            <a href="SvGenerarInforme?id=<%=p.getId_persona()%>" class="text-success font-weight-bold" title="Redactar Informe">
                                                                <i class="fas fa-plus"></i> Informe
                                                            </a>
                                                        </div>
                                                    <% } %>
                                                </div>
                                            <%
                                                    }
                                                }
                                            %>
                                            </div>
                                        </td>
                            <%
                                        diaMes++;
                                    }
                                    celdaActual++;
                                }
                            %>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Listado con Pacientes Agendados (HTML Puro) -->
    <div class="card shadow mb-4 border-left-success" id="seccionPacientesAgendados">
        <div class="card-header py-3 bg-white d-flex flex-wrap justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-success">
                <i class="fas fa-clipboard-list mr-1"></i> Listado de Pacientes Agendados
            </h6>
            <div class="mt-2 mt-md-0">
                <% if (esUsuarioMedico) { %>
                    <a href="calendario-citas.jsp?filtroAgenda=mis_citas&mes=<%=mes%>&anio=<%=anio%>" class="btn btn-sm <%=filtroAgenda.equals("mis_citas") ? "btn-success font-weight-bold" : "btn-outline-success"%> mr-1">
                        <i class="fas fa-user-md mr-1"></i> Mis Pacientes Agendados
                    </a>
                    <a href="calendario-citas.jsp?filtroAgenda=todas&mes=<%=mes%>&anio=<%=anio%>" class="btn btn-sm <%=filtroAgenda.equals("todas") ? "btn-primary font-weight-bold" : "btn-outline-primary"%>">
                        <i class="fas fa-users mr-1"></i> Todos los Agendados
                    </a>
                <% } else { %>
                    <span class="badge badge-light border">Total citas: <%=listaCitas != null ? listaCitas.size() : 0%></span>
                <% } %>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                    <thead class="thead-light">
                        <tr>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Paciente</th>
                            <th>DNI</th>
                            <th>Teléfono</th>
                            <th>Seguro</th>
                            <th>Médico Asignado</th>
                            <th>Motivo Consulta</th>
                            <th style="white-space: nowrap;">Acciones Clínicas</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        boolean hayCitasMostradas = false;
                        if (listaCitas != null && !listaCitas.isEmpty()) {
                            for (Cita c : listaCitas) {
                                boolean mostrar = true;
                                if (esUsuarioMedico && "mis_citas".equals(filtroAgenda)) {
                                    mostrar = (c.getCitaMedico() != null && c.getCitaMedico().getId_persona() == idMedicoLogueado);
                                }
                                if (!mostrar) continue;
                                hayCitasMostradas = true;

                                Paciente p = c.getPaciente();
                                Medico m = c.getCitaMedico();
                    %>
                        <tr>
                            <td><strong><%=c.getFecha_cita() != null ? sdfDisplay.format(c.getFecha_cita()) : "-"%></strong></td>
                            <td><span class="badge badge-info font-weight-bold" style="font-size: 0.9rem;"><i class="far fa-clock mr-1"></i><%=c.getHora_cita() != null ? SecurityUtils.escapeHtml(c.getHora_cita()) : "-"%></span></td>
                            <td>
                                <% if (p != null) { %>
                                    <a href="SvHistorialPaciente?id=<%=p.getId_persona()%>" class="text-primary font-weight-bold" title="Abrir Historial Clínico">
                                        <i class="fas fa-user-injured mr-1"></i><%=SecurityUtils.escapeHtml(p.getNombre())%> <%=SecurityUtils.escapeHtml(p.getApellido())%>
                                    </a>
                                <% } else { %>
                                    <span class="text-muted">Sin paciente</span>
                                <% } %>
                            </td>
                            <td><%=p != null && p.getDni() != null ? SecurityUtils.escapeHtml(p.getDni()) : "-"%></td>
                            <td><%=p != null && p.getTelefono() != null ? SecurityUtils.escapeHtml(p.getTelefono()) : "-"%></td>
                            <td>
                                <span class="badge badge-light border">
                                    <%=p != null && p.getSeguro_medico() != null ? SecurityUtils.escapeHtml(p.getSeguro_medico()) : "Sin seguro"%>
                                </span>
                            </td>
                            <td>
                                <%=m != null ? ("Dr./Dra. " + SecurityUtils.escapeHtml(m.getNombre()) + " " + SecurityUtils.escapeHtml(m.getApellido())) : "<span class='text-muted'>Sin asignar</span>"%>
                                <% if (m != null && m.getEspecialidad() != null) { %>
                                    <small class="d-block text-muted"><%=SecurityUtils.escapeHtml(m.getEspecialidad())%></small>
                                <% } %>
                            </td>
                            <td><%=c.getMotivo() != null ? SecurityUtils.escapeHtml(c.getMotivo()) : "-"%></td>
                            <td style="white-space: nowrap;">
                                <% if (p != null) { %>
                                <a href="SvHistorialPaciente?id=<%=p.getId_persona()%>" class="btn btn-sm btn-info mr-1" title="Ver Historial Clínico Completo">
                                    <i class="fas fa-file-medical-alt mr-1"></i> Historial
                                </a>
                                <a href="SvGenerarInforme?id=<%=p.getId_persona()%>" class="btn btn-sm btn-success mr-1" title="Redactar Informe Médico para este Paciente">
                                    <i class="fas fa-plus mr-1"></i> Informe
                                </a>
                                <% } %>
                                <form action="SvEliminarCita" method="POST" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="<%=SecurityUtils.obtenerOGenerarTokenCsrf(request.getSession())%>">
                                    <input type="hidden" name="id" value="<%=c.getId_cita()%>">
                                    <input type="hidden" name="origen" value="calendario">
                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Cancelar cita">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%      }
                        }
                        if (!hayCitasMostradas) {
                    %>
                        <tr>
                            <td colspan="9" class="text-center py-4 text-muted">
                                <i class="fas fa-calendar-check fa-2x mb-2 d-block text-gray-400"></i>
                                <% if (esUsuarioMedico && "mis_citas".equals(filtroAgenda)) { %>
                                    No tienes pacientes agendados en este momento. <a href="calendario-citas.jsp?filtroAgenda=todas">Ver todas las citas de la clínica</a>
                                <% } else { %>
                                    No hay citas agendadas actualmente. <a href="SvNuevaCita">¡Agendar una cita ahora!</a>
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
