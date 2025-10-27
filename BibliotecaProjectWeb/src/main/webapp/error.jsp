<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Error - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.jsp">📚 Biblioteca Comunitaria</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="index.jsp">← Volver al Inicio</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body text-center p-5">
                        <div class="mb-4">
                            <h1 class="display-1 text-danger">⚠️</h1>
                        </div>
                        
                        <h2 class="text-danger mb-4">Error</h2>
                        
                        <div class="alert alert-danger">
                            <h5>Descripción del Error:</h5>
                            <p class="mb-0">
                                <%= request.getAttribute("error") != null ? 
                                    request.getAttribute("error") : 
                                    "Ha ocurrido un error inesperado" %>
                            </p>
                        </div>
                        
                        <div class="mt-4">
                            <a href="index.jsp" class="btn btn-primary me-3">
                                🏠 Ir al Inicio
                            </a>
                            <a href="ListarMateriales" class="btn btn-outline-secondary">
                                📚 Ver Catálogo
                            </a>
                        </div>
                        
                        <div class="mt-4">
                            <small class="text-muted">
                                Si el problema persiste, contacte al administrador del sistema.
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5 py-4 bg-light text-center">
        <div class="container">
            <p class="text-muted mb-0">© 2025 Biblioteca Comunitaria - Sistema de Gestión de Préstamos</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

