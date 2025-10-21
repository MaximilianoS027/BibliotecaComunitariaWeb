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
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
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
                <div class="alert alert-<%= "BIBLIOTECARIO".equals(rol) ? "success" : "primary" %>" role="alert" style="z-index: 1; position: relative;">
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
                        <a href="MisPrestamos" class="btn btn-primary">Ver Préstamos</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">📚 Catálogo</h5>
                        <p class="card-text">Explora nuestra colección completa</p>
                        <a href="ListarMateriales" class="btn btn-info text-white">Ver Catálogo</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">➕ Nuevo Préstamo</h5>
                        <p class="card-text">Solicita un nuevo préstamo de material</p>
                        <a href="NuevoPrestamo" class="btn btn-success">Solicitar</a>
                    </div>
                </div>
            </div>
        </div>
        <% } else if ("BIBLIOTECARIO".equals(rol)) { %>
        <!-- Dashboard para Bibliotecario -->
        <div class="row mt-4 row-cols-1 row-cols-lg-3 g-4">
            <!-- Botón Lectores -->
            <div class="col">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center d-flex flex-column">
                        <div class="mb-3">
                            <i class="fas fa-users fa-3x text-success"></i>
                        </div>
                        <h5 class="card-title">👥 Lectores</h5>
                        <p class="card-text flex-grow-1">Gestionar lectores del sistema, registrar nuevos usuarios y administrar estados</p>
                        <a href="ListarLectores" class="btn btn-success btn-lg w-100 mt-auto">Gestionar Lectores</a>
                    </div>
                </div>
            </div>
            
            <!-- Botón Materiales -->
            <div class="col">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center d-flex flex-column">
                        <div class="mb-3">
                            <i class="fas fa-books fa-3x text-info"></i>
                        </div>
                        <h5 class="card-title">📚 Materiales</h5>
                        <p class="card-text flex-grow-1">Administrar catálogo de libros y artículos especiales, agregar nuevos materiales</p>
                        <a href="ListarLibros" class="btn btn-info btn-lg w-100 mt-auto text-white">Gestionar Materiales</a>
                    </div>
                </div>
            </div>
            
            <!-- Botón Préstamos -->
            <div class="col">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center d-flex flex-column">
                        <div class="mb-3">
                            <i class="fas fa-clipboard-list fa-3x text-warning"></i>
                        </div>
                        <h5 class="card-title">📋 Préstamos</h5>
                        <p class="card-text flex-grow-1">Supervisar préstamos activos, gestionar devoluciones y estados</p>
                        <a href="ListarPrestamos" class="btn btn-warning btn-lg w-100 mt-auto">Gestionar Préstamos</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Sección de Reportes -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h4 class="mb-0">📊 Reportes y Estadísticas del Sistema</h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- Estadísticas Generales -->
                            <div class="col-md-3">
                                <div class="text-center p-3 bg-light rounded">
                                    <h3 class="text-success mb-1">150</h3>
                                    <p class="text-muted mb-0">Total Lectores</p>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="text-center p-3 bg-light rounded">
                                    <h3 class="text-info mb-1">89</h3>
                                    <p class="text-muted mb-0">Libros Disponibles</p>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="text-center p-3 bg-light rounded">
                                    <h3 class="text-warning mb-1">23</h3>
                                    <p class="text-muted mb-0">Préstamos Activos</p>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="text-center p-3 bg-light rounded">
                                    <h3 class="text-danger mb-1">5</h3>
                                    <p class="text-muted mb-0">Préstamos Vencidos</p>
                                </div>
                            </div>
                        </div>
                        
                        <hr class="my-4">
                        
                        <!-- Gráficas -->
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0">📈 Préstamos por Mes</h6>
                                    </div>
                                    <div class="card-body">
                                        <canvas id="prestamosChart" width="400" height="200"></canvas>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0">📚 Tipos de Material</h6>
                                    </div>
                                    <div class="card-body">
                                        <canvas id="materialesChart" width="400" height="200"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mt-3">
                            <div class="col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0">👥 Lectores por Estado</h6>
                                    </div>
                                    <div class="card-body">
                                        <canvas id="lectoresChart" width="400" height="150"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
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
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom JS -->
    <script src="assets/js/app.js"></script>
    
    <% if ("BIBLIOTECARIO".equals(rol)) { %>
    <script>
        // Gráfica de Préstamos por Mes
        const prestamosCtx = document.getElementById('prestamosChart').getContext('2d');
        new Chart(prestamosCtx, {
            type: 'line',
            data: {
                labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                datasets: [{
                    label: 'Préstamos',
                    data: [12, 19, 15, 25, 22, 30, 28, 35, 32, 40, 38, 45],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Gráfica de Tipos de Material
        const materialesCtx = document.getElementById('materialesChart').getContext('2d');
        new Chart(materialesCtx, {
            type: 'doughnut',
            data: {
                labels: ['Libros', 'Artículos Especiales'],
                datasets: [{
                    data: [75, 25],
                    backgroundColor: [
                        'rgba(54, 162, 235, 0.8)',
                        'rgba(255, 205, 86, 0.8)'
                    ],
                    borderColor: [
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 205, 86, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Gráfica de Lectores por Estado
        const lectoresCtx = document.getElementById('lectoresChart').getContext('2d');
        new Chart(lectoresCtx, {
            type: 'bar',
            data: {
                labels: ['Activos', 'Suspendidos', 'Inactivos'],
                datasets: [{
                    label: 'Cantidad de Lectores',
                    data: [120, 15, 15],
                    backgroundColor: [
                        'rgba(40, 167, 69, 0.8)',
                        'rgba(220, 53, 69, 0.8)',
                        'rgba(108, 117, 125, 0.8)'
                    ],
                    borderColor: [
                        'rgba(40, 167, 69, 1)',
                        'rgba(220, 53, 69, 1)',
                        'rgba(108, 117, 125, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
    <% } %>
</body>
</html>


