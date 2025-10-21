<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Verificar que el usuario esté autenticado
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuarioId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String rol = (String) userSession.getAttribute("rol");
    String email = (String) userSession.getAttribute("usuarioEmail");
    String usuarioId = (String) userSession.getAttribute("usuarioId");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Mi Perfil - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark <%= "BIBLIOTECARIO".equals(rol) ? "bg-success" : "bg-primary" %>">
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
                    <% if ("LECTOR".equals(rol)) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="MisPrestamos">Mis Préstamos</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="ListarMateriales">Catálogo</a>
                        </li>
                    <% } else if ("BIBLIOTECARIO".equals(rol)) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="ListarLectores">Lectores</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="ListarLibros">Materiales</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="ListarPrestamos">Préstamos</a>
                        </li>
                    <% } %>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            👤 <%= email %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item active" href="perfil.jsp">Mi Perfil</a></li>
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
                <h2>👤 Mi Perfil</h2>
                <p class="text-muted">Gestiona tu información personal y configuración de cuenta</p>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Información Personal</h5>
                        <form>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" value="<%= email %>" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="rol" class="form-label">Rol</label>
                                        <input type="text" class="form-control" id="rol" value="<%= rol %>" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="usuarioId" class="form-label">ID de Usuario</label>
                                <input type="text" class="form-control" id="usuarioId" value="<%= usuarioId %>" readonly>
                            </div>
                            <div class="alert alert-info" role="alert">
                                <h6 class="alert-heading">ℹ️ Información</h6>
                                <p class="mb-0">Para modificar tu información personal, contacta con un bibliotecario.</p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Acciones Rápidas</h5>
                        <div class="d-grid gap-2">
                            <a href="home.jsp" class="btn btn-primary">Volver al Inicio</a>
                            <% if ("LECTOR".equals(rol)) { %>
                                <a href="misPrestamos.jsp" class="btn btn-outline-primary">Mis Préstamos</a>
                                <a href="catalogo.jsp" class="btn btn-outline-info">Ver Catálogo</a>
                            <% } else if ("BIBLIOTECARIO".equals(rol)) { %>
                                <a href="gestionLectores.jsp" class="btn btn-outline-success">Gestionar Lectores</a>
                                <a href="gestionMateriales.jsp" class="btn btn-outline-success">Gestionar Materiales</a>
                                <a href="gestionPrestamos.jsp" class="btn btn-outline-success">Gestionar Préstamos</a>
                            <% } %>
                        </div>
                    </div>
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
</body>
</html>
