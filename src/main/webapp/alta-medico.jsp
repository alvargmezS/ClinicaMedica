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
                                <h1 class="h4 text-gray-900 mb-4">Crear nuevo Médico</h1>
                            </div>
                            <form action="SvMedicos" method="POST" class="user">
                                <!-- Datos Personales -->
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
                                        <input type="text" class="form-control form-control-user" name="especialidad" placeholder="Especialidad (ej: Cardiología)" required>
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

                                <!-- Credenciales de Usuario -->
                                <hr>
                                <h6 class="text-gray-900 font-weight-bold">Datos de Acceso al Sistema:</h6>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="text" class="form-control form-control-user" name="usuario" placeholder="Nombre de usuario" required>
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="password" class="form-control form-control-user" name="pass" placeholder="Contraseña" required>
                                    </div>
                                </div>

                                <!-- Botón de Envío -->
                                <button type="submit" class="btn btn-primary btn-user btn-block mt-4">
                                    Registrar Médico
                                </button>
                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

<%@ include file="components/body2.jsp"%>
