<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.prestamo.DtPrestamo" %>
<%@ page import="publicadores.lector.DtLector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.xml.datatype.XMLGregorianCalendar" %>
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
    
    // Obtener datos
    DtLector lector = (DtLector) request.getAttribute("lector");
    @SuppressWarnings("unchecked")
    List<DtPrestamo> prestamos = (List<DtPrestamo>) request.getAttribute("prestamos");
    @SuppressWarnings("unchecked")
    List<DtPrestamo> prestamosActivos = (List<DtPrestamo>) request.getAttribute("prestamosActivos");
    
    Integer totalPrestamos = (Integer) request.getAttribute("totalPrestamos");
    Integer totalActivos = (Integer) request.getAttribute("totalActivos");
    Integer totalPendientes = (Integer) request.getAttribute("totalPendientes");
    Integer totalEnCurso = (Integer) request.getAttribute("totalEnCurso");
    Integer totalDevueltos = (Integer) request.getAttribute("totalDevueltos");
    
    String filtroEstado = (String) request.getAttribute("filtroEstado");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    
    // Inicializar valores por defecto
    if (prestamos == null) prestamos = new java.util.ArrayList<>();
    if (prestamosActivos == null) prestamosActivos = new java.util.ArrayList<>();
    if (totalPrestamos == null) totalPrestamos = 0;
    if (totalActivos == null) totalActivos = 0;
    if (totalPendientes == null) totalPendientes = 0;
    if (totalEnCurso == null) totalEnCurso = 0;
    if (totalDevueltos == null) totalDevueltos = 0;
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<%!
    // Método helper para formatear fechas
    private String formatearFecha(XMLGregorianCalendar xmlCalendar) {
        if (xmlCalendar == null) return "N/A";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            return sdf.format(xmlCalendar.toGregorianCalendar().getTime());
        } catch (Exception e) {
            return "N/A";
        }
    }
    
    // Método helper para obtener badge de estado
    private String getBadgeEstado(String estado) {
        if ("PENDIENTE".equals(estado)) {
            return "bg-info text-white";
        } else if ("EN_CURSO".equals(estado)) {
            return "bg-warning text-dark";
        } else if ("DEVUELTO".equals(estado)) {
            return "bg-success";
        } else {
            return "bg-secondary";
        }
    }
    
    // Método helper para obtener texto de estado
    private String getTextoEstado(String estado) {
        if ("PENDIENTE".equals(estado)) {
            return "Pendiente";
        } else if ("EN_CURSO".equals(estado)) {
            return "En Curso";
        } else if ("DEVUELTO".equals(estado)) {
            return "Devuelto";
        } else {
            return estado;
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Préstamos del Lector - Biblioteca Comunitaria</title>
    
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
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="mb-1">📋 Historial de Préstamos del Lector</h2>
                        <p class="text-muted mb-0">Control y seguimiento de préstamos</p>
                    </div>
                    <a href="ListarLectores" class="btn btn-outline-secondary">
                        ← Volver a Lectores
                    </a>
                </div>

                <!-- Mensajes de éxito/error -->
                <% if (success != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>Éxito:</strong> <%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error:</strong> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <!-- Información del Lector -->
                <% if (lector != null) { %>
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">👤 Información del Lector</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <strong>ID:</strong> <code><%= lector.getId() %></code>
                            </div>
                            <div class="col-md-3">
                                <strong>Nombre:</strong> <%= lector.getNombre() %>
                            </div>
                            <div class="col-md-3">
                                <strong>Email:</strong> <%= lector.getEmail() %>
                            </div>
                            <div class="col-md-3">
                                <strong>Zona:</strong> 
                                <span class="badge bg-info"><%= lector.getZona() %></span>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Estadísticas del Lector -->
                <div class="row mb-4">
                    <div class="col-md-2">
                        <div class="card shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">📊 Total</h5>
                                <h2 class="text-primary"><%= totalPrestamos %></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">⚠️ Activos</h5>
                                <h2 class="text-danger"><%= totalActivos %></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">⏸️ Pendientes</h5>
                                <h2 class="text-info"><%= totalPendientes %></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">⏳ En Curso</h5>
                                <h2 class="text-warning"><%= totalEnCurso %></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">✅ Devueltos</h5>
                                <h2 class="text-success"><%= totalDevueltos %></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">📈 Cumplimiento</h5>
                                <h2 class="text-success">
                                    <%= totalPrestamos > 0 ? Math.round((double)totalDevueltos / totalPrestamos * 100) : 0 %>%
                                </h2>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filtro por estado -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">🔍 Filtrar por Estado</h5>
                                <form method="get" action="ConsultarPrestamosLector">
                                    <input type="hidden" name="lectorId" value="<%= lector != null ? lector.getId() : "" %>">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <select class="form-select" name="estado">
                                                <option value="">Todos los estados</option>
                                                <option value="PENDIENTE" <%= "PENDIENTE".equals(filtroEstado) ? "selected" : "" %>>Pendiente</option>
                                                <option value="EN_CURSO" <%= "EN_CURSO".equals(filtroEstado) ? "selected" : "" %>>En Curso</option>
                                                <option value="DEVUELTO" <%= "DEVUELTO".equals(filtroEstado) ? "selected" : "" %>>Devuelto</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-success w-100">Filtrar</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla de préstamos -->
                <div class="card shadow-sm">
                    <div class="card-body">
                        <% if (prestamos != null && !prestamos.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Material</th>
                                        <th>Bibliotecario</th>
                                        <th class="text-center">Estado</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (DtPrestamo p : prestamos) { %>
                                    <tr>
                                        <td><code><%= p.getId() %></code></td>
                                        <td><%= formatearFecha(p.getFechaSolicitud()) %></td>
                                        <td><%= p.getMaterialDescripcion() != null ? p.getMaterialDescripcion() : p.getMaterialId() %></td>
                                        <td><%= p.getBibliotecarioNombre() != null ? p.getBibliotecarioNombre() : p.getBibliotecarioId() %></td>
                                        <td class="text-center">
                                            <span class="badge <%= getBadgeEstado(p.getEstado()) %>">
                                                <%= getTextoEstado(p.getEstado()) %>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="ConsultarPrestamo?id=<%= p.getId() %>" 
                                                   class="btn btn-sm btn-info text-white">
                                                    👁️ Ver
                                                </a>
                                                <% if ("PENDIENTE".equals(p.getEstado())) { %>
                                                <a href="CambiarEstadoPrestamo?id=<%= p.getId() %>&estado=EN_CURSO" 
                                                   class="btn btn-sm btn-warning text-dark"
                                                   onclick="return confirmarCambioEstado('Pendiente', 'En Curso')">
                                                    ▶️ Aprobar
                                                </a>
                                                <% } else if ("EN_CURSO".equals(p.getEstado())) { %>
                                                <a href="CambiarEstadoPrestamo?id=<%= p.getId() %>&estado=DEVUELTO" 
                                                   class="btn btn-sm btn-success"
                                                   onclick="return confirmarCambioEstado('En Curso', 'Devuelto')">
                                                    ✅ Devolver
                                                </a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info text-center">
                            <% if (lector != null) { %>
                                No hay préstamos para mostrar para el lector <strong><%= lector.getNombre() %></strong> con los filtros aplicados.
                            <% } else { %>
                                No hay préstamos para mostrar.
                            <% } %>
                        </div>
                        <% } %>
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
        // Función para confirmar cambio de estado
        function confirmarCambioEstado(estadoActual, nuevoEstado) {
            return confirm(
                '¿Está seguro de cambiar el estado del préstamo de "' + estadoActual + '" a "' + nuevoEstado + '"?\n\n' +
                'Esta acción no se puede deshacer.'
            );
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
