<%@ page import="Logica.Paciente" %>
<%@ page import="Logica.Responsable" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Logica.SecurityUtils" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 27/11/2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<%
    Paciente pac = (Paciente) request.getSession().getAttribute("pacienteEditar");
    if (pac == null) {
        response.sendRedirect("SvPacientes");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaNacFormateada = (pac.getFecha_nacimiento() != null) ? sdf.format(pac.getFecha_nacimiento()) : "";

    Responsable resp = pac.getResponsable();
    String respNom = (resp != null && resp.getNombre() != null) ? resp.getNombre() : "";
    String respApe = (resp != null && resp.getApellido() != null) ? resp.getApellido() : "";
    String respDni = (resp != null && resp.getDni() != null) ? resp.getDni() : "";
    String respTel = (resp != null && resp.getTelefono() != null) ? resp.getTelefono() : "";
    String respDir = (resp != null && resp.getDireccion() != null) ? resp.getDireccion() : "";
    String respTipo = (resp != null && resp.getTipo_responsable() != null) ? resp.getTipo_responsable() : "Padre/Madre";

    String grupo = (pac.getGrupo_sangre() != null) ? pac.getGrupo_sangre() : "Sin especificar";
%>

<div class="container">

    <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="p-5">

                        <div class="text-center mb-4">
                            <h1 class="h4 text-gray-900 font-weight-bold">
                                <i class="fas fa-user-edit text-primary mr-2"></i>Modificar Datos del Paciente
                            </h1>
                            <p class="text-gray-600 small">Actualiza los datos personales, médicos o el tutor legal del paciente</p>
                        </div>

                        <form action="SvEditarPaciente" method="POST" class="user">
                            <input type="hidden" name="id" value="<%=pac.getId_persona()%>">

                            <!-- Datos Personales -->
                            <h6 class="text-gray-900 font-weight-bold">Información Personal:</h6>
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Nombre:</label>
                                    <input type="text" class="form-control form-control-user" name="nombre" value="<%=SecurityUtils.escapeHtml(pac.getNombre())%>" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Apellidos:</label>
                                    <input type="text" class="form-control form-control-user" name="apellido" value="<%=SecurityUtils.escapeHtml(pac.getApellido())%>" required>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">DNI:</label>
                                    <input type="text" class="form-control form-control-user" name="dni" value="<%=SecurityUtils.escapeHtml(pac.getDni())%>" required>
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Teléfono:</label>
                                    <input type="tel" class="form-control form-control-user" name="telefono" value="<%=SecurityUtils.escapeHtml(pac.getTelefono() != null ? pac.getTelefono() : "")%>">
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Dirección:</label>
                                    <input type="text" class="form-control form-control-user" name="direccion" value="<%=SecurityUtils.escapeHtml(pac.getDireccion() != null ? pac.getDireccion() : "")%>">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Fecha de Nacimiento:</label>
                                    <input type="date" class="form-control form-control-user" name="fecha_nac" value="<%=fechaNacFormateada%>" required>
                                </div>
                            </div>

                            <!-- Información Médica -->
                            <hr>
                            <h6 class="text-gray-900 font-weight-bold">Información Médica:</h6>
                            <div class="form-group row">
                                <div class="col-sm-6 mb-3 mb-sm-0">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Seguro Médico / Obra Social:</label>
                                    <input type="text" class="form-control form-control-user" name="seguro_medico" value="<%=SecurityUtils.escapeHtml(pac.getSeguro_medico() != null ? pac.getSeguro_medico() : "")%>">
                                </div>
                                <div class="col-sm-6">
                                    <label class="small text-gray-700 font-weight-bold ml-2">Grupo Sanguíneo:</label>
                                    <select name="grupo_sangre" class="form-control" style="height: 50px; border-radius: 10rem;">
                                        <option value="Sin especificar" <%=grupo.equalsIgnoreCase("Sin especificar") ? "selected" : ""%>>-- Sin especificar --</option>
                                        <option value="A+" <%=grupo.equals("A+") ? "selected" : ""%>>A Positivo (A+)</option>
                                        <option value="A-" <%=grupo.equals("A-") ? "selected" : ""%>>A Negativo (A-)</option>
                                        <option value="B+" <%=grupo.equals("B+") ? "selected" : ""%>>B Positivo (B+)</option>
                                        <option value="B-" <%=grupo.equals("B-") ? "selected" : ""%>>B Negativo (B-)</option>
                                        <option value="AB+" <%=grupo.equals("AB+") ? "selected" : ""%>>AB Positivo (AB+)</option>
                                        <option value="AB-" <%=grupo.equals("AB-") ? "selected" : ""%>>AB Negativo (AB-)</option>
                                        <option value="O+" <%=grupo.equals("O+") ? "selected" : ""%>>O Positivo (O+)</option>
                                        <option value="O-" <%=grupo.equals("O-") ? "selected" : ""%>>O Negativo (O-)</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Tutor Legal / Responsable -->
                            <hr>
                            <div class="card border-left-warning shadow-sm mb-4">
                                <div class="card-body p-3">
                                    <h6 class="text-warning font-weight-bold mb-1">
                                        <i class="fas fa-user-shield mr-1"></i> Tutor Legal / Responsable (Menores de Edad)
                                    </h6>
                                    <p class="small text-muted mb-3">
                                        Si el paciente es menor de edad (&lt; 18 años), completa o actualiza los datos del tutor legal a su cargo.
                                    </p>

                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Nombre del Tutor:</label>
                                            <input type="text" class="form-control" name="resp_nombre" value="<%=SecurityUtils.escapeHtml(respNom)%>" placeholder="Nombre del tutor" style="border-radius: 10rem;">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Apellidos del Tutor:</label>
                                            <input type="text" class="form-control" name="resp_apellido" value="<%=SecurityUtils.escapeHtml(respApe)%>" placeholder="Apellidos" style="border-radius: 10rem;">
                                        </div>
                                    </div>

                                    <div class="form-group row mb-2">
                                        <div class="col-sm-6 mb-2">
                                            <label class="small text-gray-700 font-weight-bold ml-2">DNI del Tutor:</label>
                                            <input type="text" class="form-control" name="resp_dni" value="<%=SecurityUtils.escapeHtml(respDni)%>" placeholder="DNI / NIE" style="border-radius: 10rem;">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Teléfono del Tutor:</label>
                                            <input type="tel" class="form-control" name="resp_telefono" value="<%=SecurityUtils.escapeHtml(respTel)%>" placeholder="Teléfono de urgencias" style="border-radius: 10rem;">
                                        </div>
                                    </div>

                                    <div class="form-group row mb-0">
                                        <div class="col-sm-6 mb-2">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Parentesco:</label>
                                            <select name="resp_tipo" class="form-control" style="height: 40px; border-radius: 10rem;">
                                                <option value="Padre/Madre" <%=respTipo.equalsIgnoreCase("Padre/Madre") ? "selected" : ""%>>Padre / Madre</option>
                                                <option value="Tutor Legal" <%=respTipo.equalsIgnoreCase("Tutor Legal") ? "selected" : ""%>>Tutor Legal</option>
                                                <option value="Abuelo/a" <%=respTipo.equalsIgnoreCase("Abuelo/a") ? "selected" : ""%>>Abuelo / Abuela</option>
                                                <option value="Familiar a Cargo" <%=respTipo.equalsIgnoreCase("Familiar a Cargo") ? "selected" : ""%>>Familiar a Cargo</option>
                                            </select>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="small text-gray-700 font-weight-bold ml-2">Dirección del Tutor:</label>
                                            <input type="text" class="form-control" name="resp_direccion" value="<%=SecurityUtils.escapeHtml(respDir)%>" placeholder="Dirección de residencia" style="border-radius: 10rem;">
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
