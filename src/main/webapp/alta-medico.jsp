<%@ page import="java.util.List" %>
<%@ page import="Logica.Usuario" %>
<%@ page import="Logica.Controller" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 23/11/2026
  Time: 21:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<%
    List<Usuario> usuariosSinMedico = (List<Usuario>) request.getSession().getAttribute("usuariosSinMedico");
    if (usuariosSinMedico == null) {
        Controller cont = new Controller();
        usuariosSinMedico = cont.getUsuariosSinMedico();
    }
    boolean hayUsuariosDisponibles = (usuariosSinMedico != null && !usuariosSinMedico.isEmpty());
%>

<div class="container">

        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0 ">
                <!-- Nested Row within Card Body -->
                <div class="row justify-content-center">

                    <div class="col-lg-8">
                        <div class="p-5">
                            <div class="text-center">
                                <h1 class="h4 text-gray-900 mb-4 font-weight-bold">
                                    <i class="fas fa-user-md text-primary mr-2"></i>Crear nuevo Médico
                                </h1>
                            </div>
                            <form action="SvMedicos" method="POST" class="user">
                                <!-- Datos Personales -->
                                <h6 class="text-gray-900 font-weight-bold">Datos Personales:</h6>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" name="nombre" placeholder="Nombre" required>
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="text" class="form-control form-control-user" name="apellido" placeholder="Apellidos" required>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" name="dni" placeholder="DNI" required>
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="tel" class="form-control form-control-user" name="telefono" placeholder="Teléfono">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" name="direccion" placeholder="Dirección">
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="date" class="form-control form-control-user" name="fecha_nac" placeholder="Fecha de Nacimiento" required>
                                    </div>
                                </div>

                                <!-- Especialidad -->
                                <div class="form-group row">
                                    <div class="col-sm-12">
                                        <input type="text" class="form-control form-control-user" name="especialidad" placeholder="Especialidad (ej: Cardiología, Pediatría)" required>
                                    </div>
                                </div>

                                <!-- Horarios -->
                                <hr>
                                <h6 class="text-gray-900 font-weight-bold">Horario de Atención:</h6>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <label class="small text-gray-600 ml-2">Hora de Inicio:</label>
                                        <input type="time" class="form-control form-control-user" name="hora_inicio" required>
                                    </div>
                                    <div class="col-sm-6">
                                        <label class="small text-gray-600 ml-2">Hora de Fin:</label>
                                        <input type="time" class="form-control form-control-user" name="hora_fin" required>
                                    </div>
                                </div>

                                <!-- Asignación de Usuario -->
                                <hr>
                                <h6 class="text-gray-900 font-weight-bold">Asignación de Usuario al Médico:</h6>
                                
                                <div class="form-group">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Opción 1: Asignar un usuario existente (sin médico):</label>
                                    <select name="id_usuario_existente" class="form-control" style="height: 48px; border-radius: 10rem;">
                                        <option value="0">-- Ninguno (o crear uno nuevo abajo) --</option>
                                        <% if (hayUsuariosDisponibles) {
                                               for (Usuario u : usuariosSinMedico) { %>
                                            <option value="<%=u.getId_usuario()%>">
                                                <%=u.getNombre_usuario()%> (Rol actual: <%=u.getRol()%>)
                                            </option>
                                        <%     }
                                           } %>
                                    </select>
                                </div>

                                <div class="card bg-light p-3 mb-3">
                                    <h6 class="small text-gray-700 font-weight-bold mb-2">Opción 2: O crear un usuario nuevo ahora mismo:</h6>
                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2 mb-sm-0">
                                            <input type="text" class="form-control form-control-user" name="usuario" placeholder="Nombre de usuario nuevo">
                                        </div>
                                        <div class="col-sm-6">
                                            <input type="password" class="form-control form-control-user" name="pass" placeholder="Contraseña nueva">
                                        </div>
                                    </div>
                                    <div class="form-group row mb-0">
                                        <div class="col-sm-12">
                                            <label class="small text-gray-600 ml-1">Rol a asignar al nuevo usuario:</label>
                                            <select name="rol" class="form-control" style="height: 48px; border-radius: 10rem;">
                                                <option value="Medico" selected>Medico</option>
                                                <option value="Admin">Admin</option>
                                                <option value="Administrativo">Administrativo</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Botón de Envío -->
                                <button type="submit" class="btn btn-primary btn-user btn-block mt-4 font-weight-bold">
                                    <i class="fas fa-check mr-1"></i> Registrar Médico
                                </button>
                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

<%@ include file="components/body2.jsp"%>
