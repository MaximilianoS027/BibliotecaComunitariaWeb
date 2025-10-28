<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.prestamo.DtPrestamo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Verificar que el usuario esté autenticado y sea LECTOR
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuarioId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String rol = (String) userSession.getAttribute("rol");
    if (!"LECTOR".equals(rol)) {
        response.sendRedirect("home.jsp?error=permisos");
        return;
    }
    
    String email = (String) userSession.getAttribute("usuarioEmail");
    
    @SuppressWarnings("unchecked")
    List<DtPrestamo> prestamos = (List<DtPrestamo>) request.getAttribute("prestamos");
    Integer totalPrestamos = (Integer) request.getAttribute("totalPrestamos");
    String filtroEstado = (String) request.getAttribute("filtroEstado");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Mis Préstamos - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
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
                        <a class="nav-link active" href="MisPrestamos">Mis Préstamos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarMateriales">Catálogo</a>
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
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h2>📖 Mis Préstamos</h2>
                        <p class="text-light">Gestiona tus préstamos de materiales</p>
                    </div>
                    <div>
                        <a href="NuevoPrestamo" class="btn btn-success">
                            ➕ Solicitar Nuevo Préstamo
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mensajes de feedback -->
        <% if ("solicitud_enviada".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> Tu solicitud de préstamo ha sido enviada correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if ("devolucion_exitosa".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> El material ha sido devuelto correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Filtros y búsqueda -->
        <div class="row mt-3 mb-4">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <form method="get" action="MisPrestamos">
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <select class="form-select" name="estado" onchange="this.form.submit()">
                                        <option value="">Todos los estados</option>
                                        <option value="PENDIENTE" <%= "PENDIENTE".equals(filtroEstado) ? "selected" : "" %>>Pendientes</option>
                                        <option value="EN_CURSO" <%= "EN_CURSO".equals(filtroEstado) ? "selected" : "" %>>En Curso</option>
                                        <option value="DEVUELTO" <%= "DEVUELTO".equals(filtroEstado) ? "selected" : "" %>>Devueltos</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <a href="MisPrestamos" class="btn btn-outline-secondary w-100">
                                        🔄 Limpiar Filtros
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h6 class="card-title">📊 Estadísticas</h6>
                        <p class="mb-1"><strong>Total de préstamos:</strong> <%= totalPrestamos != null ? totalPrestamos : 0 %></p>
                        <p class="mb-0"><strong>Mostrando:</strong> <%= prestamos != null ? prestamos.size() : 0 %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista de préstamos -->
        <div class="row">
            <div class="col-12">
                <% if (prestamos != null && !prestamos.isEmpty()) { %>
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-primary">
                                    <tr>
                                        <th style="width: 12%;">ID</th>
                                        <th style="width: 20%;">Material</th>
                                        <th style="width: 12%;">Tipo</th>
                                        <th class="text-center" style="width: 12%;">Estado</th>
                                        <th class="text-center" style="width: 12%;">Fecha Solicitud</th>
                                        <th class="text-center" style="width: 12%;">Fecha Devolución</th>
                                        <th class="text-center" style="width: 20%;">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (DtPrestamo prestamo : prestamos) { %>
                                    <tr>
                                        <td><code><%= prestamo.getId() %></code></td>
                                        <td>
                                            <strong><%= new String(prestamo.getMaterialDescripcion().getBytes("ISO-8859-1"), "UTF-8") %></strong>
                                        </td>
                                        <td>
                                            <span class="badge bg-info"><%= prestamo.getMaterialTipo() %></span>
                                        </td>
                                        <td class="text-center">
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
                                            <span class="badge <%= badgeClass %>">
                                                <%= icono %> <%= estado %>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <% 
                                            try {
                                                Object fechaObj = prestamo.getFechaSolicitud();
                                                String fechaOut = "";
                                                if (fechaObj != null) {
                                                    if (fechaObj instanceof javax.xml.datatype.XMLGregorianCalendar) {
                                                        javax.xml.datatype.XMLGregorianCalendar xmlCal = 
                                                            (javax.xml.datatype.XMLGregorianCalendar) fechaObj;
                                                        fechaOut = sdf.format(xmlCal.toGregorianCalendar().getTime());
                                                    } else if (fechaObj instanceof java.util.Date) {
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
                                                <span class="badge bg-secondary"><%= fechaOut %></span>
                                            <% } catch (Exception e) { %>
                                                <span class="badge bg-warning">Error</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <% 
                                            try {
                                                Object devObj = prestamo.getFechaDevolucion();
                                                if (devObj != null) {
                                                    String fechaOut = "";
                                                    if (devObj instanceof javax.xml.datatype.XMLGregorianCalendar) {
                                                        javax.xml.datatype.XMLGregorianCalendar xmlCal = 
                                                            (javax.xml.datatype.XMLGregorianCalendar) devObj;
                                                        fechaOut = sdf.format(xmlCal.toGregorianCalendar().getTime());
                                                    } else if (devObj instanceof java.util.Date) {
                                                        fechaOut = sdf.format((java.util.Date) devObj);
                                                    } else {
                                                        String f = devObj.toString();
                                                        if (f.contains("T")) {
                                                            String[] p = f.split("T")[0].split("-");
                                                            if (p.length == 3) fechaOut = p[2]+"/"+p[1]+"/"+p[0];
                                                        } else if (f.contains("-")) {
                                                            String[] p = f.split("-");
                                                            if (p.length == 3) fechaOut = p[2]+"/"+p[1]+"/"+p[0];
                                                        } else if (f.contains("/")) {
                                                            fechaOut = f;
                                                        } else {
                                                            fechaOut = f;
                                                        }
                                                    }
                                            %>
                                                    <span class="badge bg-success"><%= fechaOut %></span>
                                            <%  } else { %>
                                                    <span class="badge bg-light text-dark">Pendiente</span>
                                            <%  } 
                                            } catch (Exception e) { %>
                                                <span class="badge bg-warning">Error</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="ConsultarPrestamo?id=<%= prestamo.getId() %>" 
                                                   class="btn btn-sm btn-info text-white" 
                                                   title="Ver detalles">
                                                    👁️
                                                </a>
                                                <% if ("En Uso".equals(prestamo.getEstado())) { %>
                                                <a href="DevolverPrestamo?id=<%= prestamo.getId() %>" 
                                                   class="btn btn-sm btn-warning" 
                                                   title="Devolver material"
                                                   onclick="return confirm('¿Está seguro de devolver este material?')">
                                                    📚
                                                </a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="card shadow-sm">
                    <div class="card-body text-center py-5">
                        <div class="mb-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-book text-muted" viewBox="0 0 16 16">
                                <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
                            </svg>
                        </div>
                        <h5 class="text-muted">No tienes préstamos registrados</h5>
                        <p class="text-muted mb-3">Aún no has solicitado ningún préstamo de material</p>
                        <a href="NuevoPrestamo" class="btn btn-success">
                            ➕ Solicitar tu Primer Préstamo
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Botón para refrescar -->
        <div class="row mt-3">
            <div class="col-12 text-center">
                <button onclick="location.reload()" class="btn btn-outline-secondary">
                    🔄 Actualizar Lista
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
