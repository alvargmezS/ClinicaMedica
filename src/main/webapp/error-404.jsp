<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 27/11/2026
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<div class="container-fluid text-center my-5">

    <div class="error mx-auto" data-text="404" style="font-size: 7rem; font-weight: 800; color: #5a5c69;">404</div>
    <p class="lead text-gray-800 mb-4 font-weight-bold">Página o recurso no encontrado</p>
    <p class="text-gray-500 mb-4">La dirección solicitada no existe en el sistema o fue movida.</p>
    <a href="index.jsp" class="btn btn-primary shadow-sm">
        <i class="fas fa-arrow-left mr-1"></i> Volver al Menú Principal
    </a>

</div>

<%@ include file="components/body2.jsp"%>
