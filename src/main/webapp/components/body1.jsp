<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 23/11/2026
  Time: 20:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<body id="page-top">

<%
HttpSession sesion = request.getSession();
String usuario = (String) request.getSession().getAttribute("usuario");
String rol = (String) request.getSession().getAttribute("rol");
if (rol == null) {
    rol = "";
}

if(usuario == null){ 
    response.sendRedirect("login.jsp");
    return;
}

%>
    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->
        <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

            <!-- Sidebar - Brand -->
            <a class="sidebar-brand d-flex align-items-center justify-content-center" href="index.jsp">
                <div class="sidebar-brand-icon rotate-n-15">
                    <i class="fas fa-solid fa-book-medical"></i>
                </div>
                <div class="sidebar-brand-text mx-3"> Centro Médico </div>
            </a>

            <!-- Divider -->
            <hr class="sidebar-divider my-0">

            <!-- Nav Item - Menú -->
            <li class="nav-item active">
                <a class="nav-link" href="index.jsp">
                    <i class="fas fa-whiteboard fa-semibold fa-bars"></i>
                    <span>Menú</span></a>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider">

            <!-- Heading -->
            <div class="sidebar-heading"> Gestión </div>

            <!-- Nav Item - Citas Médicas Collapse Menu (Todos los roles autenticados) -->
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseCitas"
                    aria-expanded="true" aria-controls="collapseCitas">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Citas Médicas</span>
                </a>
                <div id="collapseCitas" class="collapse" aria-labelledby="headingCitas"
                    data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">Gestión de Citas</h6>
                        <a class="collapse-item" href="calendario-citas.jsp">Calendario de Citas</a>
                        <a class="collapse-item" href="SvCitas">Histórico de Citas</a>
                        <a class="collapse-item" href="SvNuevaCita">Agendar Cita</a>
                    </div>
                </div>
            </li>

            <!-- Nav Item - Médico Collapse Menu (Admin y Administrativo) -->
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Administrativo") || rol.equalsIgnoreCase("Recepcionista")) { %>
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseMedico"
                    aria-expanded="true" aria-controls="collapseUtilities">
                    <i class="fas fs-solid fa-hospital-user"></i>
                    <span> Médicos </span>
                </a>
                <div id="collapseMedico" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">Acciones</h6>
                        <a class="collapse-item" href="SvMedicos">Ver Doctor/Doctora</a>
                        <a class="collapse-item" href="alta-medico.jsp">Alta Doctor/Doctora</a>
                    </div>
                </div>
            </li>
            <% } %>

            <!-- Nav Item - Pacientes Collapse Menu (Todos los roles autenticados) -->
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapsePaciente"
                    aria-expanded="true" aria-controls="collapseUtilities">
                    <i class="fas fa-solid fa-user"></i>
                    <span>Pacientes</span>
                </a>
                <div id="collapsePaciente" class="collapse" aria-labelledby="headingUtilities"
                    data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">Pacientes</h6>
                        <a class="collapse-item" href="SvPacientes">Ver Pacientes</a>
                        <a class="collapse-item" href="alta-paciente.jsp">Alta Paciente</a>
                        <h6 class="collapse-header">Informes Clínicos</h6>
                        <a class="collapse-item" href="SvInformes">Historial e Informes</a>
                        <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Medico") || rol.equalsIgnoreCase("Doctor")) { %>
                            <a class="collapse-item" href="SvGenerarInforme">Generar Informe</a>
                        <% } %>
                    </div>
                </div>
            </li>

            <!-- Nav Item - Administrativos Collapse Menu (SOLO Admin) -->
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador")) { %>
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseAdminPersonal"
                    aria-expanded="true" aria-controls="collapseAdminPersonal">
                    <i class="fas fa-user-tie"></i>
                    <span>Administrativos</span>
                </a>
                <div id="collapseAdminPersonal" class="collapse" aria-labelledby="headingAdminPersonal"
                    data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">Acciones</h6>
                        <a class="collapse-item" href="SvAdministrativos">Ver Administrativos</a>
                        <a class="collapse-item" href="alta-administrativo.jsp">Alta Administrativo</a>
                    </div>
                </div>
            </li>
            <% } %>

            <!-- Nav Item - Usuario Collapse Menu (SOLO Admin) -->
            <% if (rol.equalsIgnoreCase("Admin") || rol.equalsIgnoreCase("Administrador")) { %>
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUsuario"
                    aria-expanded="true" aria-controls="collapseUtilities">
                    <i class="fas fa-solid fa-users-cog"></i>
                    <span>Usuarios</span>
                </a>
                <div id="collapseUsuario" class="collapse" aria-labelledby="headingUtilities"
                    data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <h6 class="collapse-header">Acciones</h6>
                        <a class="collapse-item" href="SvUsuario">Ver Usuarios</a>
                        <a class="collapse-item" href="alta-usuario.jsp">Alta Usuario</a>
                    </div>
                </div>
            </li>
            <% } %>

        </ul>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

                    <!-- Sidebar Toggle (Topbar) -->
                    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                        <i class="fa fa-bars"></i>
                    </button>

                    <!-- Topbar Navbar -->
                    <ul class="navbar-nav ml-auto">

                        <div class="topbar-divider d-none d-sm-block"></div>

                        <!-- Nav Item - User Information -->
                        <li class="nav-item dropdown no-arrow">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="mr-2 d-none d-lg-inline text-gray-600 small">
                                    <%=usuario%> 
                                    <span class="badge badge-primary ml-1"><%=rol%></span>
                                </span>
                                <img class="img-profile rounded-circle"
                                    src="img/undraw_profile.svg">
                            </a>
                            <!-- Dropdown - User Information -->
                            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="userDropdown">
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Cerrar sesión
                                </a>
                            </div>
                        </li>

                    </ul>

                </nav>
                <!-- End of Topbar -->
