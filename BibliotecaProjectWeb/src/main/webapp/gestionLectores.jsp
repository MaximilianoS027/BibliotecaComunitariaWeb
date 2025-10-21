<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.lector.DtLector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Verificar que el usuario esté autenticado y sea BIBLIOTECARIO
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuarioId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String rol = (String) userSession.getAttribute("rol");
    if (!"BIBLIOTECARIO".equals(rol)) {
        response.sendRedirect("home.jsp?error=permisos");
        return;
    }
    
    String email = (String) userSession.getAttribute("usuarioEmail");
    
    @SuppressWarnings("unchecked")
    List<DtLector> lectores = (List<DtLector>) request.getAttribute("lectores");
    Integer totalLectores = (Integer) request.getAttribute("totalLectores");
    String filtroEstado = (String) request.getAttribute("filtroEstado");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Gestión de Lectores - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link active" href="ListarLectores">Lectores</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarLibros">Materiales</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarPrestamos">Préstamos</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            👤 <%= email %>
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
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h2>👥 Gestión de Lectores</h2>
                        <p class="text-light">Administra los lectores del sistema</p>
                    </div>
                    <div>
                        <a href="RegistroLector" class="btn btn-success">
                            ➕ Registrar Nuevo Lector
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mensajes de feedback -->
        <% if ("registro".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> El lector ha sido registrado correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Filtros y búsqueda -->
        <div class="row mt-3 mb-4">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <form method="get" action="ListarLectores">
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <select class="form-select" name="estado" onchange="this.form.submit()">
                                        <option value="">Todos los estados</option>
                                        <option value="Activo" <%= "Activo".equals(filtroEstado) ? "selected" : "" %>>Activos</option>
                                        <option value="Suspendido" <%= "Suspendido".equals(filtroEstado) ? "selected" : "" %>>Suspendidos</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <a href="ListarLectores" class="btn btn-outline-secondary w-100">
                                        🔄 Limpiar Filtros
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h6 class="card-title">📊 Estadísticas</h6>
                        <p class="mb-1"><strong>Total de lectores:</strong> <%= totalLectores != null ? totalLectores : 0 %></p>
                        <p class="mb-0"><strong>Mostrando:</strong> <%= lectores != null ? lectores.size() : 0 %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista de lectores -->
        <div class="row">
            <div class="col-12">
                <% if (lectores != null && !lectores.isEmpty()) { %>
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-success">
                                    <tr>
                                        <th style="width: 15%;">ID</th>
                                        <th style="width: 25%;">Nombre</th>
                                        <th style="width: 25%;">Email</th>
                                        <th class="text-center" style="width: 15%;">Estado</th>
                                        <th class="text-center" style="width: 10%;">Zona</th>
                                        <th class="text-center" style="width: 10%;">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (DtLector lector : lectores) { %>
                                    <tr>
                                        <td><code><%= lector.getId() %></code></td>
                                        <td><strong><%= lector.getNombre() %></strong></td>
                                        <td><%= lector.getEmail() %></td>
                                        <td class="text-center">
                                            <% if ("Activo".equals(lector.getEstado().toString())) { %>
                                                <span class="badge bg-success">Activo</span>
                                            <% } else { %>
                                                <span class="badge bg-warning">Suspendido</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-info"><%= lector.getZona() %></span>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="ConsultarLector?id=<%= lector.getId() %>" 
                                                   class="btn btn-sm btn-info text-white" 
                                                   title="Ver detalles">
                                                    👁️
                                                </a>
                                                <a href="CambiarEstadoLector?id=<%= lector.getId() %>" 
                                                   class="btn btn-sm btn-warning" 
                                                   title="Cambiar estado">
                                                    🔄
                                                </a>
                                                <a href="CambiarZonaLector?id=<%= lector.getId() %>" 
                                                   class="btn btn-sm btn-primary" 
                                                   title="Cambiar zona">
                                                    📍
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="card shadow-sm">
                    <div class="card-body text-center py-5">
                        <div class="mb-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-people text-muted" viewBox="0 0 16 16">
                                <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.456.76 1.72l-.008.002A.274.274 0 0 1 15 13H7zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816zM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275zM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4z"/>
                            </svg>
                        </div>
                        <h5 class="text-muted">No hay lectores registrados</h5>
                        <p class="text-muted mb-3">Aún no se han registrado lectores en el sistema</p>
                        <a href="RegistroLector" class="btn btn-success">
                            ➕ Registrar el Primer Lector
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Botón para refrescar -->
        <div class="row mt-3">
            <div class="col-12 text-center">
                <button onclick="location.reload()" class="btn btn-outline-secondary">
                    🔄 Actualizar Lista
                </button>
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
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
