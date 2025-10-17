<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Verificar que el usuario esté autenticado como bibliotecario
    HttpSession userSession = request.getSession(false);
    if (userSession == null || !"BIBLIOTECARIO".equals(userSession.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Reportes - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="gestionBibliotecarios.jsp">Bibliotecarios</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="agregarBibliotecario.jsp">Agregar Bibliotecario</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="reportes.jsp">Reportes</a>
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
                        <h2>📊 Reportes del Sistema</h2>
                        <p class="text-muted">Estadísticas y análisis de la biblioteca</p>
                    </div>
                    <a href="Reportes" class="btn btn-success">
                        🔄 Actualizar Reportes
                    </a>
                </div>
            </div>
        </div>

        <!-- Alertas -->
        <c:if test="${error != null}">
            <div class="alert alert-danger" role="alert">
                ❌ ${error}
            </div>
        </c:if>

        <!-- Estadísticas Principales -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="display-4 text-primary">${totalBibliotecarios}</div>
                        <h5 class="card-title">Bibliotecarios</h5>
                        <p class="text-muted">Total registrados</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="display-4 text-success">${totalPrestamos}</div>
                        <h5 class="card-title">Préstamos</h5>
                        <p class="text-muted">Total realizados</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="display-4 text-info">${totalLibros}</div>
                        <h5 class="card-title">Libros</h5>
                        <p class="text-muted">Total en catálogo</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Estadísticas Secundarias -->
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">📈 Análisis de Productividad</h5>
                        <div class="row">
                            <div class="col-6">
                                <div class="text-center">
                                    <h3 class="text-success">${prestamosPorBibliotecario}</h3>
                                    <small class="text-muted">Préstamos por Bibliotecario</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="text-center">
                                    <h3 class="text-info">${librosPorPrestamo}</h3>
                                    <small class="text-muted">Libros por Préstamo</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">📋 Resumen Ejecutivo</h5>
                        <ul class="list-unstyled">
                            <li><strong>Bibliotecarios activos:</strong> ${totalBibliotecarios}</li>
                            <li><strong>Préstamos totales:</strong> ${totalPrestamos}</li>
                            <li><strong>Libros disponibles:</strong> ${totalLibros}</li>
                            <li><strong>Promedio préstamos/bibliotecario:</strong> ${prestamosPorBibliotecario}</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Listas Detalladas -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">👥 Bibliotecarios</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${bibliotecarios != null && bibliotecarios.length > 0}">
                                <div class="list-group list-group-flush">
                                    <c:forEach var="bibliotecario" items="${bibliotecarios}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>${bibliotecario}</span>
                                                <span class="badge bg-success rounded-pill">Activo</span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${bibliotecarios.length > 5}">
                                        <div class="list-group-item text-center">
                                            <small class="text-muted">... y ${bibliotecarios.length - 5} más</small>
                                        </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-center">No hay bibliotecarios registrados</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">📚 Libros Recientes</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${libros != null && libros.length > 0}">
                                <div class="list-group list-group-flush">
                                    <c:forEach var="libro" items="${libros}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <div class="list-group-item">
                                                <span>${libro}</span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${libros.length > 5}">
                                        <div class="list-group-item text-center">
                                            <small class="text-muted">... y ${libros.length - 5} más</small>
                                        </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-center">No hay libros registrados</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">📋 Préstamos Recientes</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${prestamos != null && prestamos.length > 0}">
                                <div class="list-group list-group-flush">
                                    <c:forEach var="prestamo" items="${prestamos}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <div class="list-group-item">
                                                <span>${prestamo}</span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${prestamos.length > 5}">
                                        <div class="list-group-item text-center">
                                            <small class="text-muted">... y ${prestamos.length - 5} más</small>
                                        </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-center">No hay préstamos registrados</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Acciones -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">🔧 Acciones de Reporte</h5>
                        <div class="d-grid gap-2 d-md-flex">
                            <a href="Reportes" class="btn btn-success">
                                🔄 Actualizar Datos
                            </a>
                            <button type="button" class="btn btn-outline-primary" onclick="imprimirReporte()">
                                🖨️ Imprimir Reporte
                            </button>
                            <button type="button" class="btn btn-outline-info" onclick="exportarDatos()">
                                📊 Exportar Datos
                            </button>
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
    
    <script>
        function imprimirReporte() {
            window.print();
        }

        function exportarDatos() {
            // Simular exportación de datos
            alert('Función de exportación en desarrollo');
        }

        // Auto-refresh cada 60 segundos
        setInterval(function() {
            if (document.visibilityState === 'visible') {
                window.location.href = 'Reportes';
            }
        }, 60000);
    </script>
</body>
</html>

