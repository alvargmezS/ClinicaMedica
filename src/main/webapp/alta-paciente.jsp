<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 27/11/2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<div class="container">

    <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="p-5">

                        <div class="text-center mb-4">
                            <h1 class="h4 text-gray-900 font-weight-bold">
                                <i class="fas fa-user-plus text-primary mr-2"></i>Registrar Nuevo Paciente
                            </h1>
                            <p class="text-gray-600 small">Ingresa los datos personales, médicos y el tutor legal / responsable si es menor de edad</p>
                        </div>

                        <form action="SvPacientes" method="POST" class="user">

                            <!-- Datos Personales -->
                            <h6 class="text-gray-900 font-weight-bold">Información Personal:</h6>
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
                                    <input type="text" class="form-control form-control-user" name="direccion" placeholder="Dirección de residencia">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Fecha de Nacimiento:</label>
                                    <input type="date" class="form-control form-control-user" name="fecha_nac" required>
                                </div>
                            </div>

                            <!-- Información Médica -->
                            <hr>
                            <h6 class="text-gray-900 font-weight-bold">Información Médica:</h6>
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Seguro Médico / Obra Social:</label>
                                    <input type="text" class="form-control form-control-user" name="seguro_medico" placeholder="Ej: Sanitas, Adeslas, Particular">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Grupo Sanguíneo:</label>
                                    <select name="grupo_sangre" class="form-control" style="height: 50px; border-radius: 10rem;">
                                        <option value="Sin especificar" selected>-- Sin especificar --</option>
                                        <option value="A+">A Positivo (A+)</option>
                                        <option value="A-">A Negativo (A-)</option>
                                        <option value="B+">B Positivo (B+)</option>
                                        <option value="B-">B Negativo (B-)</option>
                                        <option value="AB+">AB Positivo (AB+)</option>
                                        <option value="AB-">AB Negativo (AB-)</option>
                                        <option value="O+">O Positivo (O+)</option>
                                        <option value="O-">O Negativo (O-)</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Responsable / Tutor Legal (Menor de edad) -->
                            <hr>
                            <div class="card border-left-warning shadow-sm mb-4">
                                <div class="card-body p-3">
                                    <h6 class="text-warning font-weight-bold mb-1">
                                        <i class="fas fa-user-shield mr-1"></i> Responsable / Tutor Legal (Requerido para Menores de Edad)
                                    </h6>
                                    <p class="small text-muted mb-3">
                                        Si el paciente es menor de 18 años, completa los datos de su padre, madre o tutor legal según normativa sanitaria.
                                    </p>

                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Nombre del Responsable:</label>
                                            <input type="text" class="form-control" name="resp_nombre" placeholder="Nombre completo del tutor" style="border-radius: 10rem;">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Apellidos del Responsable:</label>
                                            <input type="text" class="form-control" name="resp_apellido" placeholder="Apellidos" style="border-radius: 10rem;">
                                        </div>
                                    </div>

                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2">
                                            <label class="small text-gray-700 font-weight-bold ml-2">DNI del Responsable:</label>
                                            <input type="text" class="form-control" name="resp_dni" placeholder="DNI / NIE del tutor" style="border-radius: 10rem;">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Teléfono del Responsable:</label>
                                            <input type="tel" class="form-control" name="resp_telefono" placeholder="Teléfono de contacto urgente" style="border-radius: 10rem;">
                                        </div>
                                    </div>

                                    <div class="form-group row mb-0">
                                        <div class="col-sm-6 mb-2">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Parentesco / Tipo de Tutor:</label>
                                            <select name="resp_tipo" class="form-control" style="height: 40px; border-radius: 10rem;">
                                                <option value="Padre/Madre" selected>Padre / Madre</option>
                                                <option value="Tutor Legal">Tutor Legal</option>
                                                <option value="Abuelo/a">Abuelo / Abuela</option>
                                                <option value="Familiar a Cargo">Familiar a Cargo</option>
                                            </select>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Dirección del Responsable:</label>
                                            <input type="text" class="form-control" name="resp_direccion" placeholder="Dirección (si difiere de la del paciente)" style="border-radius: 10rem;">
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <!-- Botones -->
                            <div class="row mt-4">
                                <div class="col-sm-6 mb-2">
                                    <a href="SvPacientes" class="btn btn-secondary btn-user btn-block">
                                        <i class="fas fa-arrow-left mr-1"></i> Volver a Pacientes
                                    </a>
                                </div>
                                <div class="col-sm-6">
                                    <button type="submit" class="btn btn-primary btn-user btn-block font-weight-bold">
                                        <i class="fas fa-check mr-1"></i> Guardar Paciente
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
