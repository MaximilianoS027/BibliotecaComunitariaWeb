<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.libro.DtLibro" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Detalles del Libro - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
    
    <style>
        .book-detail-card {
            border: none;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border-radius: 15px;
        }
        
        .book-cover-large {
            width: 200px;
            height: 280px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: white;
            margin: 0 auto;
        }
        
        .detail-item {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #495057;
        }
        
        .detail-value {
            color: #212529;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.jsp">📚 Biblioteca Comunitaria</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="ListarMateriales">← Volver al Catálogo</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <% 
        DtLibro libro = (DtLibro) request.getAttribute("libro");
        String rol = (String) request.getAttribute("rol");
        
        if (libro != null) {
        %>
        
        <!-- Header del Libro -->
        <div class="row mb-4">
            <div class="col-12 text-center">
                <h1 class="display-5">📖 Detalles del Libro</h1>
                <p class="lead text-muted">Información completa del material</p>
            </div>
        </div>
        
        <!-- Tarjeta Principal -->
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card book-detail-card">
                    <div class="card-body p-5">
                        <div class="row">
                            <!-- Portada del Libro -->
                            <div class="col-md-4 text-center mb-4">
                                <div class="book-cover-large">
                                    📚
                                </div>
                                <div class="mt-3">
                                    <h4 class="text-primary"><%= libro.getTitulo() != null ? libro.getTitulo() : "Sin título" %></h4>
                                    <p class="text-muted">ID: <%= libro.getId() %></p>
                                </div>
                            </div>
                            
                            <!-- Detalles del Libro -->
                            <div class="col-md-8">
                                <h5 class="mb-4">📋 Información del Material</h5>
                                
                                <div class="detail-item">
                                    <div class="row">
                                        <div class="col-sm-4">
                                            <span class="detail-label">📖 Título:</span>
                                        </div>
                                        <div class="col-sm-8">
                                            <span class="detail-value"><%= libro.getTitulo() != null ? libro.getTitulo() : "No especificado" %></span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <div class="row">
                                        <div class="col-sm-4">
                                            <span class="detail-label">🔢 ID:</span>
                                        </div>
                                        <div class="col-sm-8">
                                            <span class="detail-value"><%= libro.getId() %></span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <div class="row">
                                        <div class="col-sm-4">
                                            <span class="detail-label">📄 Páginas:</span>
                                        </div>
                                        <div class="col-sm-8">
                                            <span class="detail-value">
                                                <span class="badge bg-info text-white fs-6">
                                                    <%= libro.getCantidadPaginas() %> páginas
                                                </span>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <div class="row">
                                        <div class="col-sm-4">
                                            <span class="detail-label">📅 Fecha de Registro:</span>
                                        </div>
                                        <div class="col-sm-8">
                                            <span class="detail-value">
                                                <% if (libro.getFechaRegistro() != null) { %>
                                                    <span class="badge bg-success text-white fs-6">
                                                        <%= new SimpleDateFormat("dd/MM/yyyy").format(libro.getFechaRegistro().toGregorianCalendar().getTime()) %>
                                                    </span>
                                                <% } else { %>
                                                    <span class="text-muted">No especificada</span>
                                                <% } %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="detail-item">
                                    <div class="row">
                                        <div class="col-sm-4">
                                            <span class="detail-label">📚 Tipo:</span>
                                        </div>
                                        <div class="col-sm-8">
                                            <span class="detail-value">
                                                <span class="badge bg-primary text-white fs-6">Libro</span>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Acciones -->
        <div class="row mt-4">
            <div class="col-12 text-center">
                <div class="btn-group" role="group">
                    <a href="ListarMateriales" class="btn btn-outline-secondary">
                        ← Volver al Catálogo
                    </a>
                    
                    <% if ("LECTOR".equals(rol)) { %>
                    <a href="NuevoPrestamo?materialId=<%= libro.getId() %>&materialTipo=Libro" 
                       class="btn btn-success">
                        📋 Solicitar Préstamo
                    </a>
                    <% } %>
                    
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <a href="ListarPrestamos?filtroMaterial=<%= libro.getId() %>" 
                       class="btn btn-info">
                        📊 Ver Préstamos
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- Información Adicional -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">ℹ️ Información Adicional</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Estado:</strong> 
                                    <span class="badge bg-success">Disponible</span>
                                </p>
                                <p><strong>Ubicación:</strong> Estantería Principal</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Última actualización:</strong> <%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()) %></p>
                                <p><strong>Consultado por:</strong> <%= rol %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <% } else { %>
        
        <!-- Error -->
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="alert alert-danger text-center">
                    <h4>❌ Error</h4>
                    <p>No se pudo cargar la información del libro.</p>
                    <a href="ListarMateriales" class="btn btn-outline-danger">
                        Volver al Catálogo
                    </a>
                </div>
            </div>
        </div>
        
        <% } %>
    </div>

    <!-- Footer -->
    <footer class="mt-5 py-4 bg-light text-center">
        <div class="container">
            <p class="text-muted mb-0">© 2025 Biblioteca Comunitaria - Sistema de Gestión de Préstamos</p>
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

