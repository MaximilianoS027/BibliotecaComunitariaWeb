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
    <title>Cambiar Estado - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="ListarMateriales">Materiales</a>
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
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-warning text-dark">
                        <h4 class="mb-0">🔄 Cambiar Estado del Lector</h4>
                    </div>
                    <div class="card-body">
                        <!-- Información del lector -->
                        <div class="alert alert-info" role="alert">
                            <h6 class="alert-heading">👤 Información del Lector</h6>
                            <p class="mb-1"><strong>Nombre:</strong> <%= lector.getNombre() %></p>
                            <p class="mb-1"><strong>Email:</strong> <%= lector.getEmail() %></p>
                            <p class="mb-0"><strong>Estado actual:</strong> 
                                <% 
                                String estadoActual = lector.getEstado().toString().toUpperCase();
                                if ("ACTIVO".equals(estadoActual)) { 
                                %>
                                    <span class="badge bg-success">Activo</span>
                                <% } else { %>
                                    <span class="badge bg-warning">Suspendido</span>
                                <% } %>
                            </p>
                        </div>
                        
                        <% if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error:</strong> <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                        
                        <form action="CambiarEstadoLector" method="post" onsubmit="return confirmarCambio()">
                            <input type="hidden" name="id" value="<%= lector.getId() %>">
                            
                            <div class="mb-4">
                                <label for="nuevoEstado" class="form-label fw-bold">Nuevo Estado *</label>
                                <select class="form-select form-select-lg" id="nuevoEstado" name="nuevoEstado" required>
                                    <option value="">Seleccione el nuevo estado</option>
                                    <% 
                                    String estadoStr = lector.getEstado().toString().toUpperCase();
                                    %>
                                    <option value="Activo" <%= "ACTIVO".equals(estadoStr) ? "selected" : "" %>>Activo</option>
                                    <option value="Suspendido" <%= "SUSPENDIDO".equals(estadoStr) ? "selected" : "" %>>Suspendido</option>
                                </select>
                                <div class="form-text">
                                    <strong>Activo:</strong> El lector puede realizar préstamos y usar todos los servicios.<br>
                                    <strong>Suspendido:</strong> El lector no puede realizar préstamos hasta que se reactive su cuenta.
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
                                                <p class="mb-1"><strong>Estado actual:</strong></p>
                                                <% 
                                                String estadoPreview = lector.getEstado().toString().toUpperCase();
                                                if ("ACTIVO".equals(estadoPreview)) { 
                                                %>
                                                    <span class="badge bg-success fs-6">Activo</span>
                                                <% } else { %>
                                                    <span class="badge bg-warning fs-6">Suspendido</span>
                                                <% } %>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1"><strong>Nuevo estado:</strong></p>
                                                <span id="previewEstado" class="badge fs-6">Seleccione un estado</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-warning" role="alert">
                                <h6 class="alert-heading">⚠️ Confirmación Requerida</h6>
                                <p class="mb-0">Esta acción cambiará el estado del lector y afectará sus permisos en el sistema. ¿Está seguro de continuar?</p>
                            </div>
                            
                            <div class="d-flex gap-2 justify-content-end">
                                <a href="ConsultarLector?id=<%= lector.getId() %>" class="btn btn-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-warning">
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
        // Actualizar preview del estado
        document.getElementById('nuevoEstado').addEventListener('change', function() {
            const preview = document.getElementById('previewEstado');
            const estado = this.value;
            
            if (estado === 'Activo') {
                preview.textContent = 'Activo';
                preview.className = 'badge bg-success fs-6';
            } else if (estado === 'Suspendido') {
                preview.textContent = 'Suspendido';
                preview.className = 'badge bg-warning fs-6';
            } else {
                preview.textContent = 'Seleccione un estado';
                preview.className = 'badge fs-6';
            }
        });
        
        function confirmarCambio() {
            const nuevoEstado = document.getElementById('nuevoEstado').value;
            const estadoActualRaw = '<%= lector.getEstado().toString().toUpperCase() %>';
            
            // Normalizar estados para comparación
            const estadoActual = estadoActualRaw === 'ACTIVO' ? 'Activo' : 'Suspendido';
            
            if (nuevoEstado === '') {
                alert('Por favor seleccione un nuevo estado');
                return false;
            }
            
            if (nuevoEstado === estadoActual) {
                alert('El nuevo estado es igual al estado actual. No se realizará ningún cambio.');
                return false;
            }
            
            const confirmacion = confirm(
                '¿Está seguro de cambiar el estado del lector de "' + estadoActual + '" a "' + nuevoEstado + '"?\n\n' +
                'Esta acción afectará los permisos del lector en el sistema.'
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
