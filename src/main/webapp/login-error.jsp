<%@ page import="Logica.SecurityUtils" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 25/11/2026
  Time: 18:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String mensajeError = (String) session.getAttribute("mensajeErrorLogin");
    if (mensajeError != null) {
        session.removeAttribute("mensajeErrorLogin");
    } else {
        mensajeError = "Usuario o contraseña no válidos.";
    }
%>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Centro Médico - Inicio de Sesión">

    <title>Login Centro Médico</title>

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-gradient-primary">

    <div class="container min-vh-100 d-flex justify-content-center align-items-center">

        <!-- Outer Row -->
        <div class="row justify-content-center w-100">

            <div class="col-xl-5 col-lg-6 col-md-8 col-sm-10">

                <div class="card o-hidden border-0 shadow-lg my-5">
                    <div class="card-body p-0">
                        <!-- Nested Row within Card Body -->
                        <div class="row justify-content-center">

                            <div class="col-lg-12">
                                <div class="p-5">
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-4 font-weight-bold">
                                            <i class="fas fa-lock text-danger mr-2"></i>Iniciar Sesión
                                        </h1>
                                    </div>
                                    <form class="user" action="SvLogin" method="post">

                                        <div class="alert alert-danger py-2 small shadow-sm mb-3">
                                            <i class="fas fa-exclamation-circle mr-1"></i>
                                            <%=SecurityUtils.escapeHtml(mensajeError)%>
                                        </div>

                                        <div class="form-group">
                                            <input type="text" class="form-control form-control-user"
                                                id="usuario" name="usuario"
                                                placeholder="Nombre de Usuario" required autofocus autocomplete="username">
                                        </div>
                                        <div class="form-group">
                                            <input type="password" class="form-control form-control-user"
                                                id="pass" name="pass" placeholder="Contraseña" required autocomplete="current-password">
                                        </div>

                                        <button type="submit" class="btn btn-primary btn-user btn-block font-weight-bold">
                                            Ingresar
                                        </button>

                                    </form>
                                    <hr>
                                    <div class="text-center">
                                        <a class="small text-muted" href="login.jsp">Volver a intentar</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

</body>
</html>
