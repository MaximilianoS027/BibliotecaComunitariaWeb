<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.libro.DtLibro" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Verificar que el usuario esté autenticado
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuarioId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String rol = (String) userSession.getAttribute("rol");
    String email = (String) userSession.getAttribute("usuarioEmail");
    DtLibro libro = (DtLibro) request.getAttribute("libro");
    String success = request.getParameter("success");
    
    if (libro == null) {
        response.sendRedirect("ListarLibros?error=libro_no_encontrado");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Detalle Libro - Biblioteca Comunitaria</title>
    
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
                    <li class="nav-item">
                        <a class="nav-link" href="ListarLibros">Catálogo</a>
                    </li>
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="AgregarLibro">Agregar Libro</a>
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
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="home.jsp">Inicio</a></li>
                        <li class="breadcrumb-item"><a href="ListarLibros">Catálogo</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Detalle del Libro</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <% if ("modificar".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> El libro ha sido modificado correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header <%= "BIBLIOTECARIO".equals(rol) ? "bg-success" : "bg-primary" %> text-white">
                        <h4 class="mb-0">📖 Información del Libro</h4>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless">
                            <tbody>
                                <tr>
                                    <th scope="row" style="width: 30%;">ID:</th>
                                    <td><code><%= libro.getId() %></code></td>
                                </tr>
                                <tr>
                                    <th scope="row">Título:</th>
                                    <td><strong class="fs-5"><%= libro.getTitulo() %></strong></td>
                                </tr>
                                <tr>
                                    <th scope="row">Cantidad de Páginas:</th>
                                    <td><span class="badge bg-info"><%= libro.getCantidadPaginas() %> páginas</span></td>
                                </tr>
                                <tr>
                                    <th scope="row">Fecha de Registro:</th>
                                    <td>
                                        <% if (libro.getFechaRegistro() != null) { %>
                                            <%= sdf.format(libro.getFechaRegistro()) %>
                                        <% } else { %>
                                            No disponible
                                        <% } %>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <hr>
                        
                        <div class="d-flex gap-2 justify-content-between">
                            <a href="ListarLibros" class="btn btn-secondary">
                                ⬅️ Volver al Catálogo
                            </a>
                            
                            <% if ("BIBLIOTECARIO".equals(rol)) { %>
                            <div class="d-flex gap-2">
                                <a href="ModificarLibro?id=<%= libro.getId() %>" class="btn btn-warning">
                                    ✏️ Editar Libro
                                </a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <!-- Información adicional -->
                <div class="card shadow-sm">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">📊 Estadísticas</h6>
                    </div>
                    <div class="card-body">
                        <p class="mb-2"><strong>Estado:</strong> <span class="badge bg-success">Disponible</span></p>
                        <p class="mb-2"><strong>Préstamos activos:</strong> 0</p>
                        <p class="mb-0"><strong>Total de préstamos:</strong> 0</p>
                    </div>
                </div>
                
                <% if ("LECTOR".equals(rol)) { %>
                <div class="card shadow-sm mt-3">
                    <div class="card-body text-center">
                        <h6 class="card-title">¿Quieres este libro?</h6>
                        <p class="card-text small">Solicita un préstamo de este material</p>
                        <button class="btn btn-success btn-sm w-100" onclick="solicitarPrestamo()">
                            📋 Solicitar Préstamo
                        </button>
                    </div>
                </div>
                <% } %>
                
                <% if ("BIBLIOTECARIO".equals(rol)) { %>
                <div class="card shadow-sm mt-3">
                    <div class="card-body">
                        <h6 class="card-title">⚙️ Acciones Administrativas</h6>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-primary btn-sm" onclick="verHistorial()">
                                📜 Ver Historial
                            </button>
                            <button class="btn btn-outline-info btn-sm" onclick="generarReporte()">
                                📊 Generar Reporte
                            </button>
                        </div>
                    </div>
                </div>
                <% } %>
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
        function solicitarPrestamo() {
            alert('Funcionalidad de préstamos próximamente disponible');
            // window.location.href = 'SolicitarPrestamo?libroId=<%= libro.getId() %>';
        }
        
        function verHistorial() {
            alert('Funcionalidad de historial próximamente disponible');
        }
        
        function generarReporte() {
            alert('Funcionalidad de reportes próximamente disponible');
        }
    </script>
</body>
</html>

