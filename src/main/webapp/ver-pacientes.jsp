<%@ page import="java.util.List" %>
<%@ page import="Logica.Paciente" %>
<%@ page import="Logica.Controller" %>
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
    Controller cont = new Controller();
    String csrfToken = SecurityUtils.obtenerOGenerarTokenCsrf(request.getSession());

    String busqPaciente = request.getParameter("busqPaciente");
    if (busqPaciente != null) busqPaciente = busqPaciente.trim();

    boolean busquedaActiva = (busqPaciente != null && !busqPaciente.isEmpty());

    List<Paciente> listaPacientes;
    if (busquedaActiva) {
        listaPacientes = cont.buscarPacientes(busqPaciente);
    } else {
        listaPacientes = (List<Paciente>) request.getSession().getAttribute("listaPacientes");
        if (listaPacientes == null) {
            listaPacientes = cont.getPacientes();
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Pacientes e Historiales</h1>
            <p class="mb-0 text-gray-600">Búsqueda de pacientes, consultas, generación de informes médicos e historial clínico</p>
        </div>
        <div>
            <a href="SvInformes" class="btn btn-outline-info shadow-sm mr-2">
                <i class="fas fa-notes-medical fa-sm mr-1"></i> Ver Todos los Informes
            </a>
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
            <a href="SvGenerarInforme" class="btn btn-success shadow-sm mr-2">
                <i class="fas fa-file-medical fa-sm mr-1"></i> Generar Informe
            </a>
            <% } %>
            <a href="alta-paciente.jsp" class="btn btn-primary shadow-sm">
                <i class="fas fa-user-plus fa-sm text-white-50 mr-1"></i> Alta Paciente
            </a>
        </div>
    </div>

    <!-- Barra de Búsqueda de Pacientes (HTML nativo sin JS) -->
    <div class="card shadow mb-4 border-left-info">
        <div class="card-header py-3 bg-white">
            <h6 class="m-0 font-weight-bold text-info">
                <i class="fas fa-search mr-1"></i> Buscar Pacientes por Nombre, Apellidos o DNI
            </h6>
        </div>
        <div class="card-body py-3">
            <form action="ver-pacientes.jsp" method="GET" class="form-row align-items-end">
                
                <div class="col-md-9 mb-2 mb-md-0">
                    <label class="small font-weight-bold text-gray-700">Término de Búsqueda (Nombre, Apellidos, DNI o Seguro):</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                        </div>
                        <input type="text" name="busqPaciente" class="form-control" 
                               placeholder="Ej: Juan Pérez, 12345678Z, Sanitas..." 
                               value="<%=SecurityUtils.escapeHtml(busqPaciente)%>">
                    </div>
                </div>

                <div class="col-md-3 mt-2 mt-md-0 d-flex">
                    <button type="submit" class="btn btn-info flex-grow-1 mr-2 shadow-sm">
                        <i class="fas fa-search mr-1"></i> Buscar Paciente
                    </button>
                    <% if (busquedaActiva) { %>
                    <a href="ver-pacientes.jsp" class="btn btn-outline-secondary shadow-sm" title="Limpiar búsqueda y ver todos">
                        <i class="fas fa-times mr-1"></i> Limpiar
                    </a>
                    <% } %>
                </div>

            </form>

            <% if (busquedaActiva) { %>
            <div class="mt-3 pt-2 border-top d-flex justify-content-between align-items-center">
                <span class="small text-muted">
                    Resultados de búsqueda: <strong><%=listaPacientes != null ? listaPacientes.size() : 0%> paciente(s) encontrado(s)</strong>
                    para <em>"<%=SecurityUtils.escapeHtml(busqPaciente)%>"</em>
                </span>
                <a href="ver-pacientes.jsp" class="btn btn-sm btn-link text-info p-0">Ver listado completo de pacientes</a>
            </div>
            <% } %>

        </div>
    </div>

    <!-- DataTales Pacientes -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Listado de Pacientes Registrados</h6>
            <a href="alta-paciente.jsp" class="btn btn-sm btn-primary">
                <i class="fas fa-plus mr-1"></i> Nuevo Paciente
            </a>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
                    <thead class="thead-light">
                        <tr>
                            <th>Id</th>
                            <th>Nombre</th>
                            <th>Apellidos</th>
                            <th>DNI</th>
                            <th>Teléfono</th>
                            <th>Dirección</th>
                            <th>Fecha Nacimiento</th>
                            <th>Seguro Médico</th>
                            <th>Grupo Sangre</th>
                            <th style="white-space: nowrap;">Historial e Informes</th>
                            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador")) { %>
                            <th style="width: 1%; white-space: nowrap;">Acción</th>
                            <% } %>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Id</th>
                            <th>Nombre</th>
                            <th>Apellidos</th>
                            <th>DNI</th>
                            <th>Teléfono</th>
                            <th>Dirección</th>
                            <th>Fecha Nacimiento</th>
                            <th>Seguro Médico</th>
                            <th>Grupo Sangre</th>
                            <th style="white-space: nowrap;">Historial e Informes</th>
                            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador")) { %>
                            <th style="width: 1%; white-space: nowrap;">Acción</th>
                            <% } %>
                        </tr>
                    </tfoot>

                    <tbody>

                    <% if (listaPacientes != null && !listaPacientes.isEmpty()) {
                           for (Paciente p : listaPacientes) { %>
                        <tr>
                            <td><span class="badge badge-secondary">#<%=p.getId_persona()%></span></td>
                            <td><strong><%=SecurityUtils.escapeHtml(p.getNombre())%></strong></td>
                            <td><%=SecurityUtils.escapeHtml(p.getApellido())%></td>
                            <td><%=SecurityUtils.escapeHtml(p.getDni())%></td>
                            <td><%=SecurityUtils.escapeHtml(p.getTelefono())%></td>
                            <td><%=SecurityUtils.escapeHtml(p.getDireccion())%></td>
                            <td><%=p.getFecha_nacimiento() != null ? sdf.format(p.getFecha_nacimiento()) : "-"%></td>
                            <td><span class="badge badge-info"><%=SecurityUtils.escapeHtml(p.getSeguro_medico() != null ? p.getSeguro_medico() : "Sin seguro")%></span></td>
                            <td><span class="badge badge-danger"><%=SecurityUtils.escapeHtml(p.getGrupo_sangre() != null ? p.getGrupo_sangre() : "-")%></span></td>
                            
                            <!-- Columna Historial e Informes Médicos -->
                            <td style="white-space: nowrap;">
                                <a href="SvHistorialPaciente?id=<%=p.getId_persona()%>" class="btn btn-sm btn-info mr-1" title="Ver Historial Clínico">
                                    <i class="fas fa-file-medical-alt mr-1"></i> Historial
                                </a>
                                <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
                                <a href="SvGenerarInforme?id=<%=p.getId_persona()%>" class="btn btn-sm btn-success" title="Generar Informe Médico">
                                    <i class="fas fa-plus mr-1"></i> Informe
                                </a>
                                <% } %>
                            </td>

                            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador")) { %>
                            <td style="white-space: nowrap;">
                                <form action="SvEliminarPaciente" method="post" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="<%=csrfToken%>">
                                    <input type="hidden" name="id" value="<%=p.getId_persona()%>">
                                    <button type="submit" class="btn btn-sm btn-danger">
                                        <i class="fas fa-trash-alt mr-1"></i> Eliminar
                                    </button>
                                </form>
                            </td>
                            <% } %>
                        </tr>
                    <%     }
                       } else { %>
                        <tr>
                            <td colspan="11" class="text-center py-4 text-muted">
                                <i class="fas fa-users-slash fa-2x mb-2 d-block text-gray-400"></i>
                                <% if (busquedaActiva) { %>
                                    No se encontraron pacientes para la búsqueda <em>"<%=SecurityUtils.escapeHtml(busqPaciente)%>"</em>. <a href="ver-pacientes.jsp">Ver todos los pacientes</a>
                                <% } else { %>
                                    No hay pacientes registrados. <a href="alta-paciente.jsp">¡Registrar el primer paciente!</a>
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
