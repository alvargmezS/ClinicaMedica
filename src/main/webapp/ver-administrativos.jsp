<%@ page import="java.util.List" %>
<%@ page import="Logica.Administrativo" %>
<%@ page import="Logica.SecurityUtils" %>
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
            <h1 class="h3 mb-0 text-gray-800">Personal Administrativo</h1>
            <p class="mb-0 text-gray-600">Personal de administración y recepción de la clínica médica</p>
        </div>
        <a href="alta-administrativo.jsp" class="btn btn-primary shadow-sm">
            <i class="fas fa-user-plus fa-sm text-white-50 mr-1"></i> Alta Administrativo
        </a>
    </div>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Listado de Administrativos</h6>
            <a href="alta-administrativo.jsp" class="btn btn-sm btn-success">
                <i class="fas fa-plus mr-1"></i> Nuevo Administrativo
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
                            <th>Sector / Área</th>
                            <th>Usuario Asignado</th>
                            <th style="width: 1%; white-space: nowrap;">Acción</th>
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
                            <th>Sector / Área</th>
                            <th>Usuario Asignado</th>
                            <th style="width: 1%; white-space: nowrap;">Acción</th>
                        </tr>
                    </tfoot>

                    <% List<Administrativo> lista = (List<Administrativo>) request.getSession().getAttribute("listaAdministrativos"); %>
                    <tbody>

                    <% if (lista != null && !lista.isEmpty()) {
                           for (Administrativo a : lista) { 
                               String usuarioStr = (a.getUsuarioAdministrativo() != null) 
                                       ? a.getUsuarioAdministrativo().getNombre_usuario() 
                                       : "Sin usuario";
                    %>
                        <tr>
                            <td><span class="badge badge-secondary">#<%=a.getId_persona()%></span></td>
                            <td><strong><%=SecurityUtils.escapeHtml(a.getNombre())%></strong></td>
                            <td><%=SecurityUtils.escapeHtml(a.getApellido())%></td>
                            <td><%=SecurityUtils.escapeHtml(a.getDni())%></td>
                            <td><%=a.getTelefono() != null ? SecurityUtils.escapeHtml(a.getTelefono()) : "-"%></td>
                            <td><%=a.getDireccion() != null ? SecurityUtils.escapeHtml(a.getDireccion()) : "-"%></td>
                            <td><span class="badge badge-info"><%=a.getSector() != null ? SecurityUtils.escapeHtml(a.getSector()) : "-"%></span></td>
                            <td><%=SecurityUtils.escapeHtml(usuarioStr)%></td>
                            <td style="display: flex; width: 230px;">
                                <form action="SvEditarAdministrativo" method="get">
                                    <input type="hidden" name="id" value="<%=a.getId_persona()%>">
                                    <button type="submit" style="margin-right: 5px" class="btn btn-primary btn-user btn-sm">
                                        <i class="fas fa-pencil-alt"></i> Editar
                                    </button>
                                </form>

                                <form action="SvEliminarAdministrativo" method="post">
                                    <input type="hidden" name="csrfToken" value="<%=SecurityUtils.obtenerOGenerarTokenCsrf(request.getSession())%>">
                                    <input type="hidden" name="id" value="<%=a.getId_persona()%>">
                                    <button type="submit" style="background-color: red; margin-left: 5px" class="btn btn-primary btn-user btn-sm">
                                        <i class="fas fa-solid fa-trash"></i> Eliminar
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <%     }
                       } else { %>
                        <tr>
                            <td colspan="9" class="text-center py-4 text-muted">
                                <i class="fas fa-user-tie fa-2x mb-2 d-block text-gray-400"></i>
                                No hay personal administrativo registrado. <a href="alta-administrativo.jsp">¡Registrar el primero!</a>
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
