<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.prestamo.DtPrestamo" %>
<%@ page import="publicadores.bibliotecario.DtBibliotecario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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
    @SuppressWarnings("unchecked")
    List<DtPrestamo> prestamos = (List<DtPrestamo>) request.getAttribute("prestamos");
    @SuppressWarnings("unchecked")
    List<DtPrestamo> todosPrestamos = (List<DtPrestamo>) request.getAttribute("todosPrestamos");
    @SuppressWarnings("unchecked")
    List<DtBibliotecario> bibliotecarios = (List<DtBibliotecario>) request.getAttribute("bibliotecarios");
    @SuppressWarnings("unchecked")
    Map<String, Integer> prestamosPorMaterial = (Map<String, Integer>) request.getAttribute("prestamosPorMaterial");
    
    Integer totalPrestamos = (Integer) request.getAttribute("totalPrestamos");
    Integer prestamosPendientes = (Integer) request.getAttribute("prestamosPendientes");
    Integer prestamosEnCurso = (Integer) request.getAttribute("prestamosEnCurso");
    Integer prestamosDevueltos = (Integer) request.getAttribute("prestamosDevueltos");
    
    String filtroEstado = (String) request.getAttribute("filtroEstado");
    String filtroBibliotecario = (String) request.getAttribute("filtroBibliotecario");
    String filtroZona = (String) request.getAttribute("filtroZona");
    String vistaActiva = (String) request.getAttribute("vistaActiva");
    String error = (String) request.getAttribute("error");
    
    // Inicializar valores por defecto
    if (prestamos == null) prestamos = new java.util.ArrayList<>();
    if (todosPrestamos == null) todosPrestamos = new java.util.ArrayList<>();
    if (bibliotecarios == null) bibliotecarios = new java.util.ArrayList<>();
    if (prestamosPorMaterial == null) prestamosPorMaterial = new HashMap<>();
    if (totalPrestamos == null) totalPrestamos = 0;
    if (prestamosPendientes == null) prestamosPendientes = 0;
    if (prestamosEnCurso == null) prestamosEnCurso = 0;
    if (prestamosDevueltos == null) prestamosDevueltos = 0;
    if (vistaActiva == null) vistaActiva = "todos";
    
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
    <title>Gestión de Préstamos - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
    
    <style>
        /* Mejorar visibilidad de las pestañas */
        .nav-tabs .nav-link {
            border: 2px solid #dee2e6;
            border-radius: 8px 8px 0 0;
            margin-right: 5px;
            transition: all 0.3s ease;
            background-color: #f8f9fa;
            color: #495057 !important;
            font-weight: 600;
            padding: 12px 20px;
        }
        
        .nav-tabs .nav-link:hover {
            border-color: #007bff;
            background-color: #e3f2fd;
            color: #007bff !important;
        }
        
        .nav-tabs .nav-link.active {
            border-color: #007bff;
            border-bottom-color: white;
            background-color: white;
            color: #007bff !important;
            font-weight: bold;
        }
    </style>
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
                        <a class="nav-link active" href="ListarPrestamos">Préstamos</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownUser" 
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
                <h2>📋 Gestión de Préstamos</h2>
                <p class="text-muted">Control y seguimiento completo de préstamos</p>
            </div>
        </div>

        <!-- Mensajes de error -->
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Estadísticas Generales -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">📊 Total Préstamos</h5>
                        <h2 class="text-primary"><%= totalPrestamos %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">⏸️ Pendientes</h5>
                        <h2 class="text-info"><%= prestamosPendientes %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">⏳ En Curso</h5>
                        <h2 class="text-warning"><%= prestamosEnCurso %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">✅ Devueltos</h5>
                        <h2 class="text-success"><%= prestamosDevueltos %></h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabs Navigation -->
        <ul class="nav nav-tabs mb-4" id="prestamosTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link <%= "todos".equals(vistaActiva) ? "active" : "" %>" 
                        id="todos-tab" data-bs-toggle="tab" 
                        data-bs-target="#todos" type="button" role="tab">
                    📋 Todos los Préstamos
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%= "historial".equals(vistaActiva) ? "active" : "" %>" 
                        id="historial-tab" data-bs-toggle="tab" 
                        data-bs-target="#historial" type="button" role="tab">
                    👤 Historial por Bibliotecario
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%= "zona".equals(vistaActiva) ? "active" : "" %>" 
                        id="zona-tab" data-bs-toggle="tab" 
                        data-bs-target="#zona" type="button" role="tab">
                    🗺️ Reporte por Zona
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%= "materiales".equals(vistaActiva) ? "active" : "" %>" 
                        id="materiales-tab" data-bs-toggle="tab" 
                        data-bs-target="#materiales" type="button" role="tab">
                    📚 Materiales más Prestados
                </button>
            </li>
        </ul>

        <div class="tab-content" id="prestamosTabContent">
            <!-- TAB 1: TODOS LOS PRÉSTAMOS -->
            <div class="tab-pane fade <%= "todos".equals(vistaActiva) ? "show active" : "" %>" 
                 id="todos" role="tabpanel">
                
                <!-- Filtro por estado -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">🔍 Filtrar por Estado</h5>
                                <form method="get" action="ListarPrestamos">
                                    <input type="hidden" name="vista" value="todos">
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
                            <table class="table table-hover" id="tablaTodosPrestamos">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Lector</th>
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
                                        <td><%= p.getLectorNombre() != null ? p.getLectorNombre() : p.getLectorId() %></td>
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
                            No hay préstamos para mostrar con los filtros aplicados.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- TAB 2: HISTORIAL POR BIBLIOTECARIO -->
            <div class="tab-pane fade <%= "historial".equals(vistaActiva) ? "show active" : "" %>" 
                 id="historial" role="tabpanel">
                
                <!-- Filtro por bibliotecario -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">🔍 Seleccionar Bibliotecario</h5>
                                <form method="get" action="ListarPrestamos">
                                    <input type="hidden" name="vista" value="historial">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <select class="form-select" name="bibliotecarioId" required>
                                                <option value="">Seleccione un bibliotecario...</option>
                                                <% for (DtBibliotecario bib : bibliotecarios) { %>
                                                <option value="<%= bib.getNumeroEmpleado() %>" 
                                                        <%= bib.getNumeroEmpleado().equals(filtroBibliotecario) ? "selected" : "" %>>
                                                    <%= bib.getNombre() %> (<%= bib.getEmail() %>)
                                                </option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-success w-100">Consultar</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla de préstamos del bibliotecario -->
                <div class="card shadow-sm">
                    <div class="card-body">
                        <% if (filtroBibliotecario != null && !filtroBibliotecario.isEmpty()) { %>
                            <h5>Préstamos gestionados por: <strong><%= filtroBibliotecario %></strong></h5>
                            <hr>
                        <% } %>
                        
                        <% if (prestamos != null && !prestamos.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Fecha Devolución</th>
                                        <th>Lector</th>
                                        <th>Material</th>
                                        <th class="text-center">Estado</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (DtPrestamo p : prestamos) { %>
                                    <tr>
                                        <td><code><%= p.getId() %></code></td>
                                        <td><%= formatearFecha(p.getFechaSolicitud()) %></td>
                                        <td><%= formatearFecha(p.getFechaDevolucion()) %></td>
                                        <td><%= p.getLectorNombre() != null ? p.getLectorNombre() : p.getLectorId() %></td>
                                        <td><%= p.getMaterialDescripcion() != null ? p.getMaterialDescripcion() : p.getMaterialId() %></td>
                                        <td class="text-center">
                                            <span class="badge <%= getBadgeEstado(p.getEstado()) %>">
                                                <%= p.getEstado() %>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <a href="ConsultarPrestamo?id=<%= p.getId() %>" 
                                               class="btn btn-sm btn-info text-white">
                                                👁️ Ver Detalles
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else if (filtroBibliotecario != null && !filtroBibliotecario.isEmpty()) { %>
                        <div class="alert alert-info text-center">
                            Este bibliotecario no tiene préstamos registrados.
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning text-center">
                            Por favor, seleccione un bibliotecario para ver su historial.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- TAB 3: REPORTE POR ZONA -->
            <div class="tab-pane fade <%= "zona".equals(vistaActiva) ? "show active" : "" %>" 
                 id="zona" role="tabpanel">
                
                <!-- Filtro por zona -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">🔍 Seleccionar Zona</h5>
                                <form method="get" action="ListarPrestamos">
                                    <input type="hidden" name="vista" value="zona">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <select class="form-select" name="zona" required>
                                                <option value="">Seleccione una zona...</option>
                                                <option value="Biblioteca Central" <%= "Biblioteca Central".equals(filtroZona) ? "selected" : "" %>>Biblioteca Central</option>
                                                <option value="Sucursal Este" <%= "Sucursal Este".equals(filtroZona) ? "selected" : "" %>>Sucursal Este</option>
                                                <option value="Sucursal Oeste" <%= "Sucursal Oeste".equals(filtroZona) ? "selected" : "" %>>Sucursal Oeste</option>
                                                <option value="Biblioteca Infantil" <%= "Biblioteca Infantil".equals(filtroZona) ? "selected" : "" %>>Biblioteca Infantil</option>
                                                <option value="Archivo General" <%= "Archivo General".equals(filtroZona) ? "selected" : "" %>>Archivo General</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-success w-100">Consultar</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h6 class="card-title">📊 Resumen de la Zona</h6>
                                <p class="mb-1"><strong>Préstamos encontrados:</strong> <%= prestamos.size() %></p>
                                <% if (filtroZona != null && !filtroZona.isEmpty()) { %>
                                <p class="mb-0"><strong>Zona consultada:</strong> <span class="badge bg-info"><%= filtroZona %></span></p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla de préstamos por zona -->
                <div class="card shadow-sm">
                    <div class="card-body">
                        <% if (prestamos != null && !prestamos.isEmpty()) { %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-success">
                                    <tr>
                                        <th>ID</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Lector</th>
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
                                        <td><%= p.getLectorNombre() != null ? p.getLectorNombre() : p.getLectorId() %></td>
                                        <td><%= p.getMaterialDescripcion() != null ? p.getMaterialDescripcion() : p.getMaterialId() %></td>
                                        <td><%= p.getBibliotecarioNombre() != null ? p.getBibliotecarioNombre() : p.getBibliotecarioId() %></td>
                                        <td class="text-center">
                                            <span class="badge <%= getBadgeEstado(p.getEstado()) %>">
                                                <%= p.getEstado() %>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <a href="ConsultarPrestamo?id=<%= p.getId() %>" 
                                               class="btn btn-sm btn-info text-white">
                                                👁️ Ver
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else if (filtroZona != null && !filtroZona.isEmpty()) { %>
                        <div class="alert alert-info text-center">
                            No hay préstamos para la zona seleccionada.
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning text-center">
                            Por favor, seleccione una zona para ver el reporte.
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- TAB 4: MATERIALES MÁS PRESTADOS -->
            <div class="tab-pane fade <%= "materiales".equals(vistaActiva) ? "show active" : "" %>" 
                 id="materiales" role="tabpanel">
                
                <div class="row mb-3">
                    <div class="col-12">
                        <div class="alert alert-info">
                            <strong>ℹ️ Información:</strong> Se muestran los materiales con préstamos activos (EN CURSO). 
                            Los materiales con más préstamos pendientes aparecen primero.
                        </div>
                    </div>
                </div>

                <!-- Lista de materiales con préstamos pendientes -->
                <div class="card shadow-sm">
                    <div class="card-body">
                        <% if (prestamosPorMaterial != null && !prestamosPorMaterial.isEmpty()) { %>
                        <h5>Materiales con Préstamos Pendientes</h5>
                        <hr>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-warning">
                                    <tr>
                                        <th>Material ID</th>
                                        <th class="text-center">Préstamos Pendientes</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    // Ordenar materiales por cantidad de préstamos (descendente)
                                    List<Map.Entry<String, Integer>> sortedList = new java.util.ArrayList<>(prestamosPorMaterial.entrySet());
                                    sortedList.sort((e1, e2) -> e2.getValue().compareTo(e1.getValue()));
                                    
                                    for (Map.Entry<String, Integer> entry : sortedList) { 
                                        String materialId = entry.getKey();
                                        int cantidad = entry.getValue();
                                        
                                        // Determinar el color del badge según la cantidad
                                        String badgeColor = cantidad >= 5 ? "bg-danger" : 
                                                           cantidad >= 3 ? "bg-warning text-dark" : "bg-info";
                                    %>
                                    <tr>
                                        <td><code><%= materialId %></code></td>
                                        <td class="text-center">
                                            <span class="badge <%= badgeColor %> fs-6">
                                                <%= cantidad %> préstamo<%= cantidad != 1 ? "s" : "" %>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <a href="ListarPrestamos?vista=todos&materialFilter=<%= materialId %>" 
                                               class="btn btn-sm btn-primary">
                                                Ver Préstamos
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <div class="alert alert-success text-center">
                            ✅ ¡Excelente! No hay materiales con préstamos pendientes en este momento.
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Detalle de préstamos pendientes -->
                <% if (prestamos != null && !prestamos.isEmpty()) { %>
                <div class="card shadow-sm mt-4">
                    <div class="card-body">
                        <h5>Detalle de Préstamos Pendientes</h5>
                        <hr>
                        <div class="table-responsive">
                            <table class="table table-hover table-sm">
                                <thead class="table-warning">
                                    <tr>
                                        <th>ID Préstamo</th>
                                        <th>Fecha Préstamo</th>
                                        <th>Material</th>
                                        <th>Lector</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (DtPrestamo p : prestamos) { %>
                                    <tr>
                                        <td><code><%= p.getId() %></code></td>
                                        <td><%= formatearFecha(p.getFechaSolicitud()) %></td>
                                        <td><%= p.getMaterialDescripcion() != null ? p.getMaterialDescripcion() : p.getMaterialId() %></td>
                                        <td><%= p.getLectorNombre() != null ? p.getLectorNombre() : p.getLectorId() %></td>
                                        <td class="text-center">
                                            <a href="ConsultarPrestamo?id=<%= p.getId() %>" 
                                               class="btn btn-sm btn-info text-white">
                                                Ver
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
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
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Función para confirmar cambio de estado
        function confirmarCambioEstado(estadoActual, nuevoEstado) {
            return confirm(
                '¿Está seguro de cambiar el estado del préstamo de "' + estadoActual + '" a "' + nuevoEstado + '"?\n\n' +
                'Esta acción no se puede deshacer.'
            );
        }

        // Activar el tab correcto según vistaActiva
        <% if (vistaActiva != null && !vistaActiva.equals("todos")) { %>
        document.addEventListener('DOMContentLoaded', function() {
            const tab = new bootstrap.Tab(document.getElementById('<%= vistaActiva %>-tab'));
            tab.show();
        });
        <% } %>
    </script>
</body>
</html>

