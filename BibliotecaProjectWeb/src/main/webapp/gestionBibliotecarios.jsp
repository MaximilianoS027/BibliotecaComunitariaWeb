<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Verificar que el usuario esté autenticado como bibliotecario
    HttpSession userSession = request.getSession(false);
    if (userSession == null || !"BIBLIOTECARIO".equals(userSession.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Gestión de Bibliotecarios - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container-fluid">
            <a class="navbar-brand" href="home.jsp">📚 Biblioteca Comunitaria</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                    data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="gestionBibliotecarios.jsp">Bibliotecarios</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="agregarBibliotecario.jsp">Agregar Bibliotecario</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reportes.jsp">Reportes</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            👤 <%= userSession.getAttribute("usuarioEmail") %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="perfil.jsp">Mi Perfil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="Logout">Cerrar Sesión</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2>👥 Gestión de Bibliotecarios</h2>
                        <p class="text-muted">Administra los bibliotecarios del sistema</p>
                    </div>
                    <a href="agregarBibliotecario.jsp" class="btn btn-success">
                        ➕ Agregar Bibliotecario
                    </a>
                </div>
            </div>
        </div>

        <!-- Alertas -->
        <% if (error != null) { %>
            <div class="alert alert-danger" role="alert">
                <% if ("email_requerido".equals(error)) { %>
                    ❌ Email requerido para la operación.
                <% } else if ("bibliotecario_no_existe".equals(error)) { %>
                    ❌ El bibliotecario no existe en el sistema.
                <% } else { %>
                    ❌ Error en la operación. Intente nuevamente.
                <% } %>
            </div>
        <% } %>

        <% if (success != null) { %>
            <div class="alert alert-success" role="alert">
                <% if ("bibliotecario_agregado".equals(success)) { %>
                    ✅ Bibliotecario agregado exitosamente.
                <% } else if ("bibliotecario_modificado".equals(success)) { %>
                    ✅ Bibliotecario modificado exitosamente.
                <% } else { %>
                    ✅ Operación completada exitosamente.
                <% } %>
            </div>
        <% } %>

        <!-- Estadísticas -->
        <div class="row mt-4">
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Total Bibliotecarios</h5>
                        <h2 class="text-success">${totalBibliotecarios}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">Lista de Bibliotecarios</h5>
                            <a href="ListarBibliotecarios" class="btn btn-outline-primary btn-sm">
                                🔄 Actualizar
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de Bibliotecarios -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${bibliotecarios != null && bibliotecarios.length > 0}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-success">
                                            <tr>
                                                <th>Email</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="bibliotecario" items="${bibliotecarios}">
                                                <tr>
                                                    <td>
                                                        <strong>${bibliotecario}</strong>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="ModificarBibliotecario?email=${bibliotecario}" 
                                                               class="btn btn-outline-primary btn-sm">
                                                                ✏️ Editar
                                                            </a>
                                                            <button type="button" 
                                                                    class="btn btn-outline-info btn-sm"
                                                                    onclick="verDetalles('${bibliotecario}')">
                                                                👁️ Ver Detalles
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <h5 class="text-muted">No hay bibliotecarios registrados</h5>
                                    <p class="text-muted">Comienza agregando el primer bibliotecario al sistema.</p>
                                    <a href="agregarBibliotecario.jsp" class="btn btn-success">
                                        ➕ Agregar Primer Bibliotecario
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para ver detalles -->
    <div class="modal fade" id="modalDetalles" tabindex="-1" aria-labelledby="modalDetallesLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalDetallesLabel">Detalles del Bibliotecario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="detallesContent">
                        <!-- Contenido cargado dinámicamente -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <a href="#" id="btnEditar" class="btn btn-primary">Editar</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5 py-4 bg-light text-center">
        <div class="container">
            <p class="text-muted mb-0">© 2025 Biblioteca Comunitaria</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Custom JS -->
    <script src="assets/js/app.js"></script>
    
    <script>
        function verDetalles(email) {
            // Cargar detalles del bibliotecario
            $('#detallesContent').html(`
                <div class="text-center">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">Cargando...</span>
                    </div>
                </div>
            `);
            
            // Simular carga de datos (en una implementación real, harías una llamada AJAX)
            setTimeout(function() {
                $('#detallesContent').html(`
                    <div class="row">
                        <div class="col-12">
                            <p><strong>Email:</strong> ${email}</p>
                            <p><strong>Estado:</strong> <span class="badge bg-success">Activo</span></p>
                            <p><strong>Fecha de registro:</strong> No disponible</p>
                        </div>
                    </div>
                `);
                $('#btnEditar').attr('href', 'ModificarBibliotecario?email=' + email);
            }, 1000);
            
            $('#modalDetalles').modal('show');
        }

        // Auto-refresh cada 30 segundos
        setInterval(function() {
            if (document.visibilityState === 'visible') {
                window.location.href = 'ListarBibliotecarios';
            }
        }, 30000);
    </script>
</body>
</html>

