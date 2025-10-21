<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.lector.DtLector" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Verificar que el usuario esté autenticado
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuarioId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String rol = (String) userSession.getAttribute("rol");
    String usuarioId = (String) userSession.getAttribute("usuarioId");
    String email = (String) userSession.getAttribute("usuarioEmail");
    
    DtLector lector = (DtLector) request.getAttribute("lector");
    if (lector == null) {
        response.sendRedirect("ListarLectores?error=lector_no_encontrado");
        return;
    }
    
    // Control de acceso: LECTOR solo puede ver su propio perfil
    if ("LECTOR".equals(rol) && !lector.getId().equals(usuarioId)) {
        response.sendRedirect("home.jsp?error=permisos");
        return;
    }
    
    String success = request.getParameter("success");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Perfil de Lector - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-<%= "BIBLIOTECARIO".equals(rol) ? "success" : "primary" %>">
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
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
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
                        <h2>👤 Perfil del Lector</h2>
                        <p class="text-light">Información detallada del lector</p>
                    </div>
                    <div>
                        <% if ("BIBLIOTECARIO".equals(rol)) { %>
                        <a href="ListarLectores" class="btn btn-secondary">
                            ⬅️ Volver a Lista
                        </a>
                        <% } else { %>
                        <a href="home.jsp" class="btn btn-secondary">
                            ⬅️ Volver al Inicio
                        </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mensajes de feedback -->
        <% if ("estado_cambiado".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> El estado del lector ha sido actualizado correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if ("zona_cambiada".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> La zona del lector ha sido actualizada correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Información del lector -->
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-<%= "BIBLIOTECARIO".equals(rol) ? "success" : "primary" %> text-white">
                        <h5 class="mb-0">📋 Información Personal</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">ID del Lector:</label>
                                    <p class="form-control-plaintext"><code><%= lector.getId() %></code></p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Estado:</label>
                                    <p class="form-control-plaintext">
                                        <% if ("Activo".equals(lector.getEstado().toString())) { %>
                                            <span class="badge bg-success fs-6">Activo</span>
                                        <% } else { %>
                                            <span class="badge bg-warning fs-6">Suspendido</span>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Nombre Completo:</label>
                                    <p class="form-control-plaintext"><%= lector.getNombre() %></p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Email:</label>
                                    <p class="form-control-plaintext"><%= lector.getEmail() %></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Zona Asignada:</label>
                                    <p class="form-control-plaintext">
                                        <span class="badge bg-info fs-6"><%= lector.getZona() %></span>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Fecha de Registro:</label>
                                    <p class="form-control-plaintext">
                                        <% 
                                        try {
                                            String fechaStr = sdf.format(lector.getFechaRegistro());
                                        %>
                                            <span class="badge bg-secondary fs-6"><%= fechaStr %></span>
                                        <% 
                                        } catch (Exception e) {
                                        %>
                                            <span class="badge bg-warning fs-6">Error al mostrar fecha</span>
                                        <% 
                                        }
                                        %>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Dirección:</label>
                            <p class="form-control-plaintext"><%= lector.getDireccion() %></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Panel de acciones (solo para BIBLIOTECARIO) -->
            <% if ("BIBLIOTECARIO".equals(rol)) { %>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h6 class="mb-0">⚙️ Acciones</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="CambiarEstadoLector?id=<%= lector.getId() %>" 
                               class="btn btn-warning">
                                🔄 Cambiar Estado
                            </a>
                            <a href="CambiarZonaLector?id=<%= lector.getId() %>" 
                               class="btn btn-primary">
                                📍 Cambiar Zona
                            </a>
                        </div>
                        
                        <hr>
                        
                        <div class="text-center">
                            <small class="text-muted">
                                <strong>Estado actual:</strong><br>
                                <% if ("Activo".equals(lector.getEstado().toString())) { %>
                                    <span class="text-success">✅ Activo</span>
                                <% } else { %>
                                    <span class="text-warning">⚠️ Suspendido</span>
                                <% } %>
                            </small>
                        </div>
                    </div>
                </div>
                
                <!-- Información adicional -->
                <div class="card shadow-sm mt-3">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">ℹ️ Información Adicional</h6>
                    </div>
                    <div class="card-body">
                        <small class="text-muted">
                            <strong>Zona:</strong> <%= lector.getZona() %><br>
                            <strong>Registrado:</strong> 
                            <% 
                            try {
                                String fechaStr = sdf.format(lector.getFechaRegistro());
                            %>
                                <%= fechaStr %>
                            <% 
                            } catch (Exception e) {
                            %>
                                Fecha no disponible
                            <% 
                            }
                            %>
                        </small>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
        <!-- Botón para refrescar -->
        <div class="row mt-3">
            <div class="col-12 text-center">
                <button onclick="location.reload()" class="btn btn-outline-secondary">
                    🔄 Actualizar Información
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
