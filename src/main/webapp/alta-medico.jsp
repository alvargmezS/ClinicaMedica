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

<div class="container">

        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0 ">
                <!-- Nested Row within Card Body -->
                <div class="row justify-content-center">

                    <div class="col-lg-7">
                        <div class="p-5">
                            <div class="text-center">
                                <h1 class="h4 text-gray-900 mb-4">Crear nuevo Médico </h1>
                            </div>
                            <form class="user">
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" id="nombre" name="nombre"
                                            placeholder="Nombre">
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="text" class="form-control form-control-user" id="apellido" name="apellido"
                                            placeholder="Apellidos">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" id="dni" name="dni"
                                            placeholder="DNI">
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="text" class="form-control form-control-user" id="phone" name="phone"
                                            placeholder="teléfono">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" id="especialidad" name="especialidad"
                                            placeholder="Especialidad">
                                    </div>

                                </div>

                                <a href="" class="btn btn-primary btn-user btn-block">
                                    Registrar
                                </a>

                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

<%@ include file="components/body2.jsp"%>