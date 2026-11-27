<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 27/11/2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<div class="container-fluid text-center my-5">

    <div class="error mx-auto text-danger" style="font-size: 7rem; font-weight: 800;">500</div>
    <p class="lead text-gray-800 mb-3 font-weight-bold">Ha ocurrido un error inesperado en el servidor</p>
    <p class="text-gray-500 mb-4 col-md-6 mx-auto">
        La solicitud no pudo procesarse correctamente. Por motivos de seguridad, los detalles técnicos del incidente se han registrado internamente en los registros del sistema.
    </p>
    <a href="index.jsp" class="btn btn-primary shadow-sm">
        <i class="fas fa-home mr-1"></i> Volver al Menú Principal
    </a>

</div>

<%@ include file="components/body2.jsp"%>
