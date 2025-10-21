<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.prestamo.DtPrestamo" %>
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
    
    DtPrestamo prestamo = (DtPrestamo) request.getAttribute("prestamo");
    if (prestamo == null) {
        response.sendRedirect("MisPrestamos?error=prestamo_no_encontrado");
        return;
    }
    
    // Control de acceso: LECTOR solo puede ver sus propios préstamos
    if ("LECTOR".equals(rol) && !prestamo.getLectorId().equals(usuarioId)) {
        response.sendRedirect("home.jsp?error=permisos");
        return;
    }
    
    String error = request.getParameter("error");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Detalle del Préstamo - Biblioteca Comunitaria</title>
    
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
                    <% if ("LECTOR".equals(rol)) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="MisPrestamos">Mis Préstamos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarMateriales">Catálogo</a>
                    </li>
                    <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarLectores">Lectores</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarLibros">Materiales</a>
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
                        <h2>📖 Detalle del Préstamo</h2>
                        <p class="text-light">Información completa del préstamo</p>
                    </div>
                    <div>
                        <% if ("LECTOR".equals(rol)) { %>
                        <a href="MisPrestamos" class="btn btn-secondary">
                            ⬅️ Volver a Mis Préstamos
                        </a>
                        <% } else { %>
                        <a href="ListarLectores" class="btn btn-secondary">
                            ⬅️ Volver a Lectores
                        </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mensajes de error -->
        <% if ("no_devuelto".equals(error)) { %>
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <strong>Atención:</strong> Este préstamo no puede ser devuelto en su estado actual.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Información del préstamo -->
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-<%= "BIBLIOTECARIO".equals(rol) ? "success" : "primary" %> text-white">
                        <h5 class="mb-0">📋 Información del Préstamo</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">ID del Préstamo:</label>
                                    <p class="form-control-plaintext"><code><%= prestamo.getId() %></code></p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Estado:</label>
                                    <p class="form-control-plaintext">
                                        <% 
                                        String estado = prestamo.getEstado();
                                        String badgeClass = "";
                                        String icono = "";
                                        
                                        switch (estado) {
                                            case "Solicitado":
                                                badgeClass = "bg-primary";
                                                icono = "⏳";
                                                break;
                                            case "Aprobado":
                                                badgeClass = "bg-success";
                                                icono = "✅";
                                                break;
                                            case "En Uso":
                                                badgeClass = "bg-warning";
                                                icono = "📖";
                                                break;
                                            case "Devuelto":
                                                badgeClass = "bg-secondary";
                                                icono = "📚";
                                                break;
                                            case "Rechazado":
                                                badgeClass = "bg-danger";
                                                icono = "❌";
                                                break;
                                            default:
                                                badgeClass = "bg-light text-dark";
                                                icono = "❓";
                                        }
                                        %>
                                        <span class="badge <%= badgeClass %> fs-6">
                                            <%= icono %> <%= estado %>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Material:</label>
                                    <p class="form-control-plaintext">
                                        <strong><%= new String(prestamo.getMaterialDescripcion().getBytes("ISO-8859-1"), "UTF-8") %></strong>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Tipo de Material:</label>
                                    <p class="form-control-plaintext">
                                        <span class="badge bg-info fs-6"><%= prestamo.getMaterialTipo() %></span>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Fecha de Solicitud:</label>
                                    <p class="form-control-plaintext">
                                        <% 
                                        try {
                                            Object fechaObj = prestamo.getFechaSolicitud();
                                            String fechaOut = "";
                                            if (fechaObj != null) {
                                                if (fechaObj instanceof java.util.Date) {
                                                    fechaOut = sdf.format((java.util.Date) fechaObj);
                                                } else {
                                                    String f = fechaObj.toString();
                                                    if (f.contains("T")) {
                                                        String[] p = f.split("T")[0].split("-");
                                                        if (p.length == 3) fechaOut = p[2]+"/"+p[1]+"/"+p[0];
                                                    } else if (f.contains("-")) {
                                                        String[] p = f.split("-");
                                                        if (p.length == 3) fechaOut = p[2]+"/"+p[1]+"/"+p[0];
                                                    } else {
                                                        fechaOut = f;
                                                    }
                                                }
                                            }
                                        %>
                                            <span class="badge bg-secondary fs-6"><%= fechaOut %></span>
                                        <% } catch (Exception e) { %>
                                            <span class="badge bg-warning fs-6">Error al mostrar fecha</span>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Fecha de Devolución:</label>
                                    <p class="form-control-plaintext">
                                        <% 
                                        try {
                                            Object devObj = prestamo.getFechaDevolucion();
                                            if (devObj != null) {
                                                String fechaOut = "";
                                                if (devObj instanceof java.util.Date) {
                                                    fechaOut = sdf.format((java.util.Date) devObj);
                                                } else {
                                                    String f = devObj.toString();
                                                    if (f.contains("T")) {
                                                        String[] p = f.split("T")[0].split("-");
                                                        if (p.length == 3) fechaOut = p[2]+"/"+p[1]+"/"+p[0];
                                                    } else if (f.contains("-")) {
                                                        String[] p = f.split("-");
                                                        if (p.length == 3) fechaOut = p[2]+"/"+p[1]+"/"+p[0];
                                                    } else {
                                                        fechaOut = f;
                                                    }
                                                }
                                        %>
                                                <span class="badge bg-success fs-6"><%= fechaOut %></span>
                                        <%  } else { %>
                                                <span class="badge bg-light text-dark fs-6">Pendiente</span>
                                        <%  } 
                                        } catch (Exception e) { %>
                                            <span class="badge bg-warning fs-6">Error al mostrar fecha</span>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Lector:</label>
                                    <p class="form-control-plaintext"><%= prestamo.getLectorNombre() %></p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Bibliotecario:</label>
                                    <p class="form-control-plaintext"><%= prestamo.getBibliotecarioNombre() %></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Panel de acciones (solo para LECTOR) -->
            <% if ("LECTOR".equals(rol)) { %>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h6 class="mb-0">⚙️ Acciones Disponibles</h6>
                    </div>
                    <div class="card-body">
                        <% if ("En Uso".equals(prestamo.getEstado())) { %>
                        <div class="d-grid gap-2">
                            <a href="DevolverPrestamo?id=<%= prestamo.getId() %>" 
                               class="btn btn-warning"
                               onclick="return confirm('¿Está seguro de devolver este material?')">
                                📚 Devolver Material
                            </a>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info" role="alert">
                            <small>
                                <strong>Estado:</strong> <%= prestamo.getEstado() %><br>
                                <% if ("Solicitado".equals(prestamo.getEstado())) { %>
                                    Esperando aprobación del bibliotecario
                                <% } else if ("Aprobado".equals(prestamo.getEstado())) { %>
                                    Puedes retirar el material
                                <% } else if ("Devuelto".equals(prestamo.getEstado())) { %>
                                    Préstamo completado
                                <% } else if ("Rechazado".equals(prestamo.getEstado())) { %>
                                    Préstamo rechazado
                                <% } %>
                            </small>
                        </div>
                        <% } %>
                        
                        <hr>
                        
                        <div class="text-center">
                            <small class="text-muted">
                                <strong>ID del Material:</strong><br>
                                <code><%= prestamo.getMaterialId() %></code>
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
                            <strong>Estado actual:</strong> <%= prestamo.getEstado() %><br>
                            <strong>Solicitado:</strong> 
                            <% 
                            try {
                                String fechaStr = sdf.format(prestamo.getFechaSolicitud());
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
