<%@ page import="Logica.Medico" %>
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
    Medico med = (Medico) request.getSession().getAttribute("medicoEditar");
    if (med == null) {
        response.sendRedirect("SvMedicos");
        return;
    }

    List<Usuario> usuariosDisponibles = (List<Usuario>) request.getSession().getAttribute("usuariosEditarMedico");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaNacFormateada = (med.getFecha_nacimiento() != null) ? sdf.format(med.getFecha_nacimiento()) : "";

    String horaInicio = (med.getHorarioMedico() != null && med.getHorarioMedico().getHora_inicio() != null) ? med.getHorarioMedico().getHora_inicio() : "";
    String horaFin = (med.getHorarioMedico() != null && med.getHorarioMedico().getHora_fin() != null) ? med.getHorarioMedico().getHora_fin() : "";
    int idUsuarioActual = (med.getUsuarioMedico() != null) ? med.getUsuarioMedico().getId_usuario() : 0;
%>

<div class="container">

    <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="p-5">
                        <div class="text-center">
                            <h1 class="h4 text-gray-900 mb-4 font-weight-bold">
                                <i class="fas fa-user-edit text-primary mr-2"></i>Modificar Médico
                            </h1>
                        </div>

                        <form action="SvEditarMedico" method="POST" class="user">
                            <input type="hidden" name="id" value="<%=med.getId_persona()%>">

                            <!-- Datos Personales -->
                            <h6 class="text-gray-900 font-weight-bold">Datos Personales:</h6>
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Nombre:</label>
                                    <input type="text" class="form-control form-control-user" name="nombre" value="<%=med.getNombre() != null ? med.getNombre() : ""%>" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Apellidos:</label>
                                    <input type="text" class="form-control form-control-user" name="apellido" value="<%=med.getApellido() != null ? med.getApellido() : ""%>" required>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">DNI:</label>
                                    <input type="text" class="form-control form-control-user" name="dni" value="<%=med.getDni() != null ? med.getDni() : ""%>" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Teléfono:</label>
                                    <input type="tel" class="form-control form-control-user" name="telefono" value="<%=med.getTelefono() != null ? med.getTelefono() : ""%>">
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Dirección:</label>
                                    <input type="text" class="form-control form-control-user" name="direccion" value="<%=med.getDireccion() != null ? med.getDireccion() : ""%>">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Fecha de Nacimiento:</label>
                                    <input type="date" class="form-control form-control-user" name="fecha_nac" value="<%=fechaNacFormateada%>" required>
                                </div>
                            </div>

                            <!-- Especialidad -->
                            <div class="form-group row">
                                <div class="col-sm-12">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Especialidad:</label>
                                    <input type="text" class="form-control form-control-user" name="especialidad" value="<%=med.getEspecialidad() != null ? med.getEspecialidad() : ""%>" required>
                                </div>
                            </div>

                            <!-- Horarios -->
                            <hr>
                            <h6 class="text-gray-900 font-weight-bold">Horario de Atención:</h6>
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-600 ml-2">Hora de Inicio:</label>
                                    <input type="time" class="form-control form-control-user" name="hora_inicio" value="<%=horaInicio%>" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-600 ml-2">Hora de Fin:</label>
                                    <input type="time" class="form-control form-control-user" name="hora_fin" value="<%=horaFin%>" required>
                                </div>
                            </div>

                            <!-- Asignación de Usuario -->
                            <hr>
                            <h6 class="text-gray-900 font-weight-bold">Usuario de Acceso Asignado:</h6>
                            <div class="form-group">
                                <label class="small text-gray-700 ml-2">Selecciona un usuario para este médico:</label>
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
                                    <a href="SvMedicos" class="btn btn-secondary btn-user btn-block">
                                        Volver al Listado
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
