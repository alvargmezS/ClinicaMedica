<%@ page import="java.util.List" %>
<%@ page import="Logica.Medico" %>
<%--
  Created by IntelliJ IDEA.
  User: alvargmez
  Date: 24/11/2026
  Time: 18:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="components/header.jsp"%>
<%@ include file="components/body1.jsp"%>

 <div class="container-fluid">

                    <!-- Page Heading -->
                    <h1 class="h3 mb-2 text-gray-800">Médicos</h1>
                    <p class="mb-4">Médicos registrados en el sistema</p>

                    <!-- DataTales Example -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Médicos</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="dataTable" >
                                    <thead>
                                        <tr>
                                            <th>Id</th>
                                            <th>Nombre</th>
                                            <th>Apellido</th>
                                            <th>Dni</th>
                                            <th>Dirección</th>
                                            <th>Teléfono</th>
                                            <th>Horario</th>
                                            <th style="width: 1%; white-space: nowrap;">Acción</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
                                        <tr>
                                            <th>Id</th>
                                            <th>Nombre</th>
                                            <th>Apellido</th>
                                            <th>Dni</th>
                                            <th>Dirección</th>
                                            <th>Teléfono</th>
                                            <th>Horario</th>
                                            <th style="width: 1%; white-space: nowrap;">Acción</th>
                                        </tr>
                                    </tfoot>

                                    <% List<Medico> listaMedicos= (List) request.getSession().getAttribute("listaMedicos"); %>
                                    <tbody>

                                    <% for(Medico med : listaMedicos){%>
                                        <tr>
                                            <td><%=med.getId_persona()%></td>
                                            <td><%=med.getNombre()%></td>
                                            <td><%=med.getApellido()%></td>
                                            <td><%=med.getDni()%></td>
                                            <td><%=med.getDireccion()%></td>
                                            <td><%=med.getTelefono()%></td>
                                            <td><%=med.getHorarioMedico()%></td>
                                            <td style="display: flex; width: 230px;">
                                                <form action="SvEditar" method="post">

                                                    <button  type="submit" style="margin-right: 5px" class="btn btn-primary btn-user ">
                                                        <i class="fas fa-pencil-alt"></i>
                                                        Editar </button>
                                                </form>

                                                <form action="SvEliminar" method="post">

                                                    <button  type="submit" style="background-color: red; margin-left: 5px" class="btn btn-primary btn-user">
                                                        <i class="fas fa-solid fa-trash"></i>
                                                        Eliminar</button>
                                                </form>
                                            </td>

                                        </tr>
                                    <% }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                </div>
                <!-- /.container-fluid -->

            </div>

<%@ include file="components/body2.jsp"%>