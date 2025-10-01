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
    <title>Home - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link active" href="home.jsp">Inicio</a>
                    </li>
                    <% if ("LECTOR".equals(rol)) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="misPrestamos.jsp">Mis Préstamos</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="catalogo.jsp">Catálogo</a>
                        </li>
                    <% } else if ("BIBLIOTECARIO".equals(rol)) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionLectores.jsp">Lectores</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionMateriales.jsp">Materiales</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionPrestamos.jsp">Préstamos</a>
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
                            <li><a class="dropdown-item" href="perfil.jsp">Mi Perfil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="Logout" onclick="return confirm('¿Cerrar sesión?')">Cerrar Sesión</a></li>
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
                <div class="alert alert-<%= "BIBLIOTECARIO".equals(rol) ? "success" : "primary" %>" role="alert">
                    <h4 class="alert-heading">¡Bienvenido, <%= email %>!</h4>
                    <p>Has iniciado sesión como <strong><%= rol %></strong></p>
                    <hr>
                    <p class="mb-0">ID de usuario: <%= usuarioId %></p>
                </div>
            </div>
        </div>

        <% if ("LECTOR".equals(rol)) { %>
        <!-- Dashboard para Lector -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">📖 Mis Préstamos</h5>
                        <p class="card-text">Consulta el estado de tus préstamos activos</p>
                        <a href="misPrestamos.jsp" class="btn btn-primary">Ver Préstamos</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">🔍 Catálogo</h5>
                        <p class="card-text">Explora nuestra colección de materiales</p>
                        <a href="catalogo.jsp" class="btn btn-info text-white">Ver Catálogo</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">➕ Nuevo Préstamo</h5>
                        <p class="card-text">Solicita un nuevo préstamo de material</p>
                        <a href="nuevoPrestamo.jsp" class="btn btn-success">Solicitar</a>
                    </div>
                </div>
            </div>
        </div>
        <% } else if ("BIBLIOTECARIO".equals(rol)) { %>
        <!-- Dashboard para Bibliotecario -->
        <div class="row mt-4">
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">👥 Lectores</h5>
                        <p class="card-text">Gestionar lectores del sistema</p>
                        <a href="gestionLectores.jsp" class="btn btn-success">Gestionar</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">📚 Materiales</h5>
                        <p class="card-text">Registrar donaciones y materiales</p>
                        <a href="gestionMateriales.jsp" class="btn btn-success">Gestionar</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">📋 Préstamos</h5>
                        <p class="card-text">Actualizar estado de préstamos</p>
                        <a href="gestionPrestamos.jsp" class="btn btn-success">Gestionar</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">📊 Reportes</h5>
                        <p class="card-text">Generar reportes del sistema</p>
                        <a href="reportes.jsp" class="btn btn-success">Ver Reportes</a>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
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


