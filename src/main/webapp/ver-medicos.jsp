<%@ page import="java.util.List" %>
<%@ page import="Logica.Medico" %>
<%@ page import="Logica.Controller" %>
<%@ page import="Logica.SecurityUtils" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 24/11/2026
  Time: 18:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<%
    Controller cont = new Controller();
    String csrfToken = SecurityUtils.obtenerOGenerarTokenCsrf(request.getSession());

    String busqNombre = request.getParameter("busqNombre");
    String busqEspecialidad = request.getParameter("busqEspecialidad");
    if (busqNombre != null) busqNombre = busqNombre.trim();
    if (busqEspecialidad != null) busqEspecialidad = busqEspecialidad.trim();

    boolean busquedaActiva = (busqNombre != null && !busqNombre.isEmpty()) 
            || (busqEspecialidad != null && !busqEspecialidad.isEmpty() && !"todas".equalsIgnoreCase(busqEspecialidad));

    List<Medico> listaMedicos;
    if (busquedaActiva) {
        listaMedicos = cont.buscarMedicos(busqNombre, busqEspecialidad);
    } else {
        listaMedicos = (List<Medico>) request.getSession().getAttribute("listaMedicos");
        if (listaMedicos == null) {
            listaMedicos = cont.getMedicos();
        }
    }

    List<String> especialidades = cont.getEspecialidades();
%>

<div class="container-fluid">

    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-0 text-gray-800">Médicos</h1>
            <p class="mb-0 text-gray-600">Búsqueda y gestión de facultativos médicos por nombre y especialidad</p>
        </div>
        <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Administrativo") || rol.equalsIgnoreCase("Recepcionista")) { %>
        <a href="alta-medico.jsp" class="btn btn-primary shadow-sm">
            <i class="fas fa-user-md fa-sm text-white-50 mr-1"></i> Alta Doctor/Doctora
        </a>
        <% } %>
    </div>

    <!-- Barra de Búsqueda y Filtro (HTML nativo sin JS) -->
    <div class="card shadow mb-4 border-left-primary">
        <div class="card-header py-3 bg-white">
            <h6 class="m-0 font-weight-bold text-primary">
                <i class="fas fa-search mr-1"></i> Buscar Médicos por Nombre y Especialidad
            </h6>
        </div>
        <div class="card-body py-3">
            <form action="ver-medicos.jsp" method="GET" class="form-row align-items-end">
                
                <!-- Búsqueda por Nombre -->
                <div class="col-md-5 mb-2 mb-md-0">
                    <label class="small font-weight-bold text-gray-700">Nombre o Apellidos:</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                        </div>
                        <input type="text" name="busqNombre" class="form-control" 
                               placeholder="Ej: Laura, Gómez, Carlos..." 
                               value="<%=SecurityUtils.escapeHtml(busqNombre)%>">
                    </div>
                </div>

                <!-- Búsqueda por Especialidad -->
                <div class="col-md-4 mb-2 mb-md-0">
                    <label class="small font-weight-bold text-gray-700">Especialidad Médica:</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fas fa-stethoscope"></i></span>
                        </div>
                        <select name="busqEspecialidad" class="form-control">
                            <option value="todas">-- Todas las Especialidades --</option>
                            <% if (especialidades != null) {
                                   for (String esp : especialidades) { 
                                       boolean sel = (busqEspecialidad != null && busqEspecialidad.equalsIgnoreCase(esp));
                            %>
                                <option value="<%=SecurityUtils.escapeHtml(esp)%>" <%=sel ? "selected" : ""%>><%=SecurityUtils.escapeHtml(esp)%></option>
                            <%     }
                               } %>
                        </select>
                    </div>
                </div>

                <!-- Botones de Acción -->
                <div class="col-md-3 mt-2 mt-md-0 d-flex">
                    <button type="submit" class="btn btn-primary flex-grow-1 mr-2 shadow-sm">
                        <i class="fas fa-search mr-1"></i> Buscar
                    </button>
                    <% if (busquedaActiva) { %>
                    <a href="ver-medicos.jsp" class="btn btn-outline-secondary shadow-sm" title="Limpiar búsqueda y ver todos">
                        <i class="fas fa-times mr-1"></i> Limpiar
                    </a>
                    <% } %>
                </div>

            </form>

            <% if (busquedaActiva) { %>
            <div class="mt-3 pt-2 border-top d-flex justify-content-between align-items-center">
                <span class="small text-muted">
                    Resultados de búsqueda: <strong><%=listaMedicos != null ? listaMedicos.size() : 0%> médico(s) encontrado(s)</strong>
                    <% if (busqNombre != null && !busqNombre.isEmpty()) { %>
                        con nombre <em>"<%=SecurityUtils.escapeHtml(busqNombre)%>"</em>
                    <% } %>
                    <% if (busqEspecialidad != null && !busqEspecialidad.isEmpty() && !"todas".equalsIgnoreCase(busqEspecialidad)) { %>
                        y especialidad <em>"<%=SecurityUtils.escapeHtml(busqEspecialidad)%>"</em>
                    <% } %>
                </span>
                <a href="ver-medicos.jsp" class="btn btn-sm btn-link text-primary p-0">Ver listado completo</a>
            </div>
            <% } %>

        </div>
    </div>

    <!-- DataTales Médicos -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Listado de Médicos</h6>
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Administrativo") || rol.equalsIgnoreCase("Recepcionista")) { %>
            <a href="alta-medico.jsp" class="btn btn-sm btn-success">
                <i class="fas fa-plus mr-1"></i> Nuevo Médico
            </a>
            <% } %>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
                    <thead class="thead-light">
                        <tr>
                            <th>Id</th>
                            <th>Nombre</th>
                            <th>Apellido</th>
                            <th>DNI</th>
                            <th>Dirección</th>
                            <th>Teléfono</th>
                            <th>Especialidad</th>
                            <th>Horario</th>
                            <th>Usuario</th>
                            <th style="width: 1%; white-space: nowrap;">Acción</th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th>Id</th>
                            <th>Nombre</th>
                            <th>Apellido</th>
                            <th>DNI</th>
                            <th>Dirección</th>
                            <th>Teléfono</th>
                            <th>Especialidad</th>
                            <th>Horario</th>
                            <th>Usuario</th>
                            <th style="width: 1%; white-space: nowrap;">Acción</th>
                        </tr>
                    </tfoot>

                    <tbody>

                    <% if (listaMedicos != null && !listaMedicos.isEmpty()) {
                           for (Medico med : listaMedicos) { %>
                        <tr>
                            <td><span class="badge badge-secondary">#<%=med.getId_persona()%></span></td>
                            <td><strong><%=SecurityUtils.escapeHtml(med.getNombre())%></strong></td>
                            <td><%=SecurityUtils.escapeHtml(med.getApellido())%></td>
                            <td><%=SecurityUtils.escapeHtml(med.getDni())%></td>
                            <td><%=SecurityUtils.escapeHtml(med.getDireccion())%></td>
                            <td><%=SecurityUtils.escapeHtml(med.getTelefono())%></td>
                            <td><span class="badge badge-info font-weight-bold" style="font-size: 0.9rem;"><%=SecurityUtils.escapeHtml(med.getEspecialidad())%></span></td>
                            <td>
                                <%= (med.getHorarioMedico() != null)
                                        ? (SecurityUtils.escapeHtml(med.getHorarioMedico().getHora_inicio()) + " - " + SecurityUtils.escapeHtml(med.getHorarioMedico().getHora_fin()))
                                        : "<span class='text-muted'>Sin horario</span>" %>
                            </td>
                            <td>
                                <%= (med.getUsuarioMedico() != null)
                                        ? ("<span class='badge badge-light border'>" + SecurityUtils.escapeHtml(med.getUsuarioMedico().getNombre_usuario()) + "</span>")
                                        : "<span class='text-muted'>Sin usuario</span>" %>
                            </td>
                            <td style="white-space: nowrap;">
                                <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador")) { %>
                                <form action="SvEditarMedico" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="<%=med.getId_persona()%>">
                                    <button type="submit" class="btn btn-sm btn-primary">
                                        <i class="fas fa-pencil-alt mr-1"></i> Editar
                                    </button>
                                </form>

                                <form action="SvEliminarMedico" method="post" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="<%=csrfToken%>">
                                    <input type="hidden" name="id" value="<%=med.getId_persona()%>">
                                    <button type="submit" class="btn btn-sm btn-danger">
                                        <i class="fas fa-trash-alt mr-1"></i> Eliminar
                                    </button>
                                </form>
                                <% } else { %>
                                <span class="badge badge-light text-muted">Sólo lectura</span>
                                <% } %>
                            </td>

                        </tr>
                    <%     }
                       } else { %>
                        <tr>
                            <td colspan="10" class="text-center py-4 text-muted">
                                <i class="fas fa-user-md fa-2x mb-2 d-block text-gray-400"></i>
                                <% if (busquedaActiva) { %>
                                    No se encontraron médicos que coincidan con los criterios de búsqueda. <a href="ver-medicos.jsp">Ver todos los médicos</a>
                                <% } else { %>
                                    No hay médicos registrados. <a href="alta-medico.jsp">¡Registrar el primer médico!</a>
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
<!-- /.container-fluid -->

<%@ include file="components/body2.jsp"%>
