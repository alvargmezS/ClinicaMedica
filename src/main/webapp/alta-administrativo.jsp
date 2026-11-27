<%@ page import="java.util.List" %>
<%@ page import="Logica.Usuario" %>
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
    List<Usuario> usuariosSinAdmin = (List<Usuario>) request.getSession().getAttribute("usuariosSinAdministrativo");
    if (usuariosSinAdmin == null) {
        Controller cont = new Controller();
        usuariosSinAdmin = cont.getUsuariosSinAdministrativo();
    }
    boolean hayUsuariosDisponibles = (usuariosSinAdmin != null && !usuariosSinAdmin.isEmpty());
%>

<div class="container">

    <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="p-5">

                        <div class="text-center mb-4">
                            <h1 class="h4 text-gray-900 font-weight-bold">
                                <i class="fas fa-user-tie text-primary mr-2"></i>Registrar Nuevo Administrativo
                            </h1>
                            <p class="text-gray-600 small">Ingresa los datos personales, sector y usuario del personal administrativo</p>
                        </div>

                        <form action="SvAdministrativos" method="POST" class="user">

                            <!-- Datos Personales -->
                            <h6 class="text-gray-900 font-weight-bold">Datos Personales:</h6>
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Nombre:</label>
                                    <input type="text" class="form-control form-control-user" name="nombre" placeholder="Nombre" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Apellidos:</label>
                                    <input type="text" class="form-control form-control-user" name="apellido" placeholder="Apellidos" required>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">DNI:</label>
                                    <input type="text" class="form-control form-control-user" name="dni" placeholder="DNI" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Teléfono:</label>
                                    <input type="tel" class="form-control form-control-user" name="telefono" placeholder="Teléfono de contacto">
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Dirección:</label>
                                    <input type="text" class="form-control form-control-user" name="direccion" placeholder="Dirección">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Fecha de Nacimiento:</label>
                                    <input type="date" class="form-control form-control-user" name="fecha_nac" required>
                                </div>
                            </div>

                            <!-- Sector / Área de Trabajo -->
                            <div class="form-group row">
                                <div class="col-sm-12">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Sector o Área:</label>
                                    <input type="text" class="form-control form-control-user" name="sector" placeholder="Ej: Recepción, Admisión, Facturación, Recursos Humanos" required>
                                </div>
                            </div>

                            <!-- Asignación de Usuario -->
                            <hr>
                            <h6 class="text-gray-900 font-weight-bold">Asignación de Usuario al Administrativo:</h6>

                            <div class="form-group">
                                <label class="small text-gray-700 font-weight-bold ml-2">Opción 1: Asignar un usuario existente (sin administrativo asignado):</label>
                                <select name="id_usuario_existente" class="form-control" style="height: 48px; border-radius: 10rem;">
                                    <option value="0">-- Ninguno (o crear uno nuevo abajo) --</option>
                                    <% if (hayUsuariosDisponibles) {
                                           for (Usuario u : usuariosSinAdmin) { %>
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
                                            <option value="Administrativo" selected>Administrativo</option>
                                            <option value="Admin">Admin</option>
                                            <option value="Medico">Medico</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Botones -->
                            <div class="row mt-4">
                                <div class="col-sm-6 mb-2">
                                    <a href="SvAdministrativos" class="btn btn-secondary btn-user btn-block">
                                        <i class="fas fa-arrow-left mr-1"></i> Volver a Administrativos
                                    </a>
                                </div>
                                <div class="col-sm-6">
                                    <button type="submit" class="btn btn-primary btn-user btn-block font-weight-bold">
                                        <i class="fas fa-check mr-1"></i> Registrar Administrativo
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
