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
%>
<div class="container">

        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0 ">
                <!-- Nested Row within Card Body -->
                <div class="row justify-content-center">

                    <div class="col-lg-7">
                        <div class="p-5">
                            <div class="text-center">
                                <h1 class="h4 text-gray-900 mb-4">Editar Usuario</h1>
                            </div>
                            <form action="SvEditarUsuario" method="post" class="user">
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" id="nombre" name="nombre"
                                            value="<%=usu.getNombre_usuario() != null ? usu.getNombre_usuario() : ""%>" placeholder="Nombre de usuario" required>
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="password" class="form-control form-control-user" id="pass" name="pass"
                                            placeholder="Nueva contraseña (dejar en blanco para mantener la actual)">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" id="rol" name="rol"
                                            value="<%=usu.getRol() != null ? usu.getRol() : ""%>" placeholder="Rol" required>
                                    </div>

                                </div>

                                <button type="submit" class="btn btn-primary btn-user btn-block">
                                    Modificar
                                </button>

                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

<%@ include file="components/body2.jsp"%>
