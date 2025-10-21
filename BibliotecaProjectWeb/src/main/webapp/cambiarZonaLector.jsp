<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.lector.DtLector" %>
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
    DtLector lector = (DtLector) request.getAttribute("lector");
    String error = (String) request.getAttribute("error");
    
    if (lector == null) {
        response.sendRedirect("ListarLectores?error=lector_no_encontrado");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Cambiar Zona - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="ListarLectores">Lectores</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarLibros">Materiales</a>
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
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">📍 Cambiar Zona del Lector</h4>
                    </div>
                    <div class="card-body">
                        <!-- Información del lector -->
                        <div class="alert alert-info" role="alert">
                            <h6 class="alert-heading">👤 Información del Lector</h6>
                            <p class="mb-1"><strong>Nombre:</strong> <%= lector.getNombre() %></p>
                            <p class="mb-1"><strong>Email:</strong> <%= lector.getEmail() %></p>
                            <p class="mb-0"><strong>Zona actual:</strong> 
                                <span class="badge bg-info"><%= lector.getZona() %></span>
                            </p>
                        </div>
                        
                        <% if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error:</strong> <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                        
                        <form action="CambiarZonaLector" method="post" onsubmit="return confirmarCambio()">
                            <input type="hidden" name="id" value="<%= lector.getId() %>">
                            
                            <div class="mb-4">
                                <label for="nuevaZona" class="form-label fw-bold">Nueva Zona *</label>
                                <select class="form-select form-select-lg" id="nuevaZona" name="nuevaZona" required>
                                    <option value="">Seleccione la nueva zona</option>
                                    <option value="Norte" <%= "Norte".equals(lector.getZona().toString()) ? "selected" : "" %>>Norte</option>
                                    <option value="Sur" <%= "Sur".equals(lector.getZona().toString()) ? "selected" : "" %>>Sur</option>
                                    <option value="Este" <%= "Este".equals(lector.getZona().toString()) ? "selected" : "" %>>Este</option>
                                    <option value="Oeste" <%= "Oeste".equals(lector.getZona().toString()) ? "selected" : "" %>>Oeste</option>
                                    <option value="Centro" <%= "Centro".equals(lector.getZona().toString()) ? "selected" : "" %>>Centro</option>
                                </select>
                                <div class="form-text">
                                    La zona determina la ubicación geográfica del lector y puede afectar la disponibilidad de materiales y servicios.
                                </div>
                            </div>
                            
                            <!-- Preview del cambio -->
                            <div class="mb-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0">👁️ Vista Previa del Cambio</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p class="mb-1"><strong>Zona actual:</strong></p>
                                                <span class="badge bg-info fs-6"><%= lector.getZona() %></span>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1"><strong>Nueva zona:</strong></p>
                                                <span id="previewZona" class="badge fs-6">Seleccione una zona</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Información sobre las zonas -->
                            <div class="mb-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0">ℹ️ Información sobre las Zonas</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <ul class="list-unstyled mb-0">
                                                    <li><span class="badge bg-primary me-2">Norte</span> Zona norte de la ciudad</li>
                                                    <li><span class="badge bg-primary me-2">Sur</span> Zona sur de la ciudad</li>
                                                    <li><span class="badge bg-primary me-2">Este</span> Zona este de la ciudad</li>
                                                </ul>
                                            </div>
                                            <div class="col-md-6">
                                                <ul class="list-unstyled mb-0">
                                                    <li><span class="badge bg-primary me-2">Oeste</span> Zona oeste de la ciudad</li>
                                                    <li><span class="badge bg-primary me-2">Centro</span> Zona centro de la ciudad</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-warning" role="alert">
                                <h6 class="alert-heading">⚠️ Confirmación Requerida</h6>
                                <p class="mb-0">Esta acción cambiará la zona asignada al lector. ¿Está seguro de continuar?</p>
                            </div>
                            
                            <div class="d-flex gap-2 justify-content-end">
                                <a href="ConsultarLector?id=<%= lector.getId() %>" class="btn btn-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    ✅ Confirmar Cambio
                                </button>
                            </div>
                        </form>
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
        // Actualizar preview de la zona
        document.getElementById('nuevaZona').addEventListener('change', function() {
            const preview = document.getElementById('previewZona');
            const zona = this.value;
            
            if (zona !== '') {
                preview.textContent = zona;
                preview.className = 'badge bg-info fs-6';
            } else {
                preview.textContent = 'Seleccione una zona';
                preview.className = 'badge fs-6';
            }
        });
        
        function confirmarCambio() {
            const nuevaZona = document.getElementById('nuevaZona').value;
            const zonaActual = '<%= lector.getZona().toString() %>';
            
            if (nuevaZona === '') {
                alert('Por favor seleccione una nueva zona');
                return false;
            }
            
            if (nuevaZona === zonaActual) {
                alert('La nueva zona es igual a la zona actual. No se realizará ningún cambio.');
                return false;
            }
            
            const confirmacion = confirm(
                '¿Está seguro de cambiar la zona del lector de "' + zonaActual + '" a "' + nuevaZona + '"?\n\n' +
                'Esta acción afectará la ubicación geográfica asignada al lector.'
            );
            
            return confirmacion;
        }
        
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
