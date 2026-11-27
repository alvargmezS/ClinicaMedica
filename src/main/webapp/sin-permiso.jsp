<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

<div class="container-fluid">

    <!-- 403 Error Text -->
    <div class="text-center my-5 py-5">
        <div class="error mx-auto text-danger" data-text="403" style="font-size: 6rem; font-weight: 800;">403</div>
        <p class="lead text-gray-800 mb-4 font-weight-bold">Acceso Denegado</p>
        <p class="text-gray-500 mb-0">Tu rol de usuario (<strong class="text-primary"><%=rol != null ? rol : "Sin Rol"%></strong>) no tiene permisos para acceder a este recurso.</p>
        <p class="text-gray-500 mb-4">Si crees que esto es un error, por favor contacta con el administrador del sistema.</p>
        <a href="index.jsp" class="btn btn-primary btn-user">
            <i class="fas fa-arrow-left fa-sm text-white-50 mr-2"></i>Volver al Inicio
        </a>
    </div>

</div>

<%@ include file="components/body2.jsp"%>
