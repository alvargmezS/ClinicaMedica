<%@ page import="Logica.Administrativo" %>
<%@ page import="Logica.Usuario" %>
<%@ page import="java.util.List" %>
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
    Administrativo admin = (Administrativo) request.getSession().getAttribute("adminEditar");
    if (admin == null) {
        response.sendRedirect("SvAdministrativos");
        return;
    }

    List<Usuario> usuariosDisponibles = (List<Usuario>) request.getSession().getAttribute("usuariosEditarAdmin");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaNacFormateada = (admin.getFecha_nacimiento() != null) ? sdf.format(admin.getFecha_nacimiento()) : "";
    int idUsuarioActual = (admin.getUsuarioAdministrativo() != null) ? admin.getUsuarioAdministrativo().getId_usuario() : 0;
%>

<div class="container">

    <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="p-5">

                        <div class="text-center mb-4">
                            <h1 class="h4 text-gray-900 font-weight-bold">
                                <i class="fas fa-user-edit text-primary mr-2"></i>Modificar Administrativo
                            </h1>
                            <p class="text-gray-600 small">Actualiza los datos del personal administrativo</p>
                        </div>

                        <form action="SvEditarAdministrativo" method="POST" class="user">
                            <input type="hidden" name="id" value="<%=admin.getId_persona()%>">

                            <!-- Datos Personales -->
                            <h6 class="text-gray-900 font-weight-bold">Datos Personales:</h6>
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Nombre:</label>
                                    <input type="text" class="form-control form-control-user" name="nombre" value="<%=admin.getNombre() != null ? admin.getNombre() : ""%>" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Apellidos:</label>
                                    <input type="text" class="form-control form-control-user" name="apellido" value="<%=admin.getApellido() != null ? admin.getApellido() : ""%>" required>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">DNI:</label>
                                    <input type="text" class="form-control form-control-user" name="dni" value="<%=admin.getDni() != null ? admin.getDni() : ""%>" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Teléfono:</label>
                                    <input type="tel" class="form-control form-control-user" name="telefono" value="<%=admin.getTelefono() != null ? admin.getTelefono() : ""%>">
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Dirección:</label>
                                    <input type="text" class="form-control form-control-user" name="direccion" value="<%=admin.getDireccion() != null ? admin.getDireccion() : ""%>">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Fecha de Nacimiento:</label>
                                    <input type="date" class="form-control form-control-user" name="fecha_nac" value="<%=fechaNacFormateada%>" required>
                                </div>
                            </div>

                            <!-- Sector / Área -->
                            <div class="form-group row">
                                <div class="col-sm-12">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Sector o Área de Trabajo:</label>
                                    <input type="text" class="form-control form-control-user" name="sector" value="<%=admin.getSector() != null ? admin.getSector() : ""%>" required>
                                </div>
                            </div>

                            <!-- Asignación de Usuario -->
                            <hr>
                            <h6 class="text-gray-900 font-weight-bold">Usuario de Acceso Asignado:</h6>
                            <div class="form-group">
                                <label class="small text-gray-700 ml-2">Selecciona un usuario para este administrativo:</label>
                                <select name="id_usuario" class="form-control" style="height: 48px; border-radius: 10rem;">
                                    <option value="0" <%= (idUsuarioActual == 0) ? "selected" : "" %>>-- Sin usuario asignado --</option>
                                    <% if (usuariosDisponibles != null) {
                                           for (Usuario u : usuariosDisponibles) { %>
                                        <option value="<%=u.getId_usuario()%>" <%= (u.getId_usuario() == idUsuarioActual) ? "selected" : "" %>>
                                            <%=u.getNombre_usuario()%> (Rol: <%=u.getRol()%>) <%= (u.getId_usuario() == idUsuarioActual) ? "[Actual]" : "" %>
                                        </option>
                                    <%     }
                                       } %>
                                </select>
                            </div>

                            <!-- Botones -->
                            <div class="row mt-4">
                                <div class="col-sm-6 mb-2">
                                    <a href="SvAdministrativos" class="btn btn-secondary btn-user btn-block">
                                        <i class="fas fa-arrow-left mr-1"></i> Volver a la Lista
                                    </a>
                                </div>
                                <div class="col-sm-6">
                                    <button type="submit" class="btn btn-primary btn-user btn-block font-weight-bold">
                                        <i class="fas fa-save mr-1"></i> Guardar Cambios
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
