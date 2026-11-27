<%@ page import="Logica.Usuario" %><%--
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
    Usuario usu = (Usuario) request.getSession().getAttribute("usuarioEditar");
    if (usu == null) {
        response.sendRedirect("SvUsuario");
        return;
    }
    String rolActual = (usu.getRol() != null) ? usu.getRol() : "";
%>
<div class="container">

        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0 ">
                <!-- Nested Row within Card Body -->
                <div class="row justify-content-center">

                    <div class="col-lg-7">
                        <div class="p-5">
                            <div class="text-center">
                                <h1 class="h4 text-gray-900 mb-4 font-weight-bold">
                                    <i class="fas fa-user-edit text-primary mr-2"></i>Editar Usuario
                                </h1>
                            </div>
                            <form action="SvEditarUsuario" method="post" class="user">
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <label class="small text-gray-700 font-weight-bold ml-2">Nombre de Usuario:</label>
                                        <input type="text" class="form-control form-control-user" id="nombre" name="nombre"
                                            value="<%=usu.getNombre_usuario() != null ? usu.getNombre_usuario() : ""%>" placeholder="Nombre de usuario" required>
                                    </div>
                                    <div class="col-sm-6">
                                        <label class="small text-gray-700 font-weight-bold ml-2">Nueva Contraseña:</label>
                                        <input type="password" class="form-control form-control-user" id="pass" name="pass"
                                            placeholder="Dejar en blanco para conservar">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-sm-12">
                                        <label class="small text-gray-700 font-weight-bold ml-2">Rol del Usuario:</label>
                                        <select name="rol" id="rol" class="form-control" style="height: 50px; border-radius: 10rem;" required>
                                            <option value="Admin" <%= "Admin".equalsIgnoreCase(rolActual) ? "selected" : "" %>>Admin (Control total del sistema)</option>
                                            <option value="Medico" <%= "Medico".equalsIgnoreCase(rolActual) ? "selected" : "" %>>Medico (Consultas y agenda médica)</option>
                                            <option value="Administrativo" <%= "Administrativo".equalsIgnoreCase(rolActual) ? "selected" : "" %>>Administrativo (Citas y pacientes)</option>
                                        </select>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary btn-user btn-block mt-4 font-weight-bold">
                                    <i class="fas fa-save mr-1"></i> Guardar Cambios
                                </button>

                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

<%@ include file="components/body2.jsp"%>
