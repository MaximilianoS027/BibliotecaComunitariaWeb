<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.libro.DtLibro" %>
<%@ page import="publicadores.articuloespecial.DtArticuloEspecial" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.xml.datatype.XMLGregorianCalendar" %>
<%
    // Verificar que el usuario esté autenticado
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuarioId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String rol = (String) userSession.getAttribute("rol");
    String email = (String) userSession.getAttribute("usuarioEmail");
    
    // Datos del catálogo
    @SuppressWarnings("unchecked")
    List<DtLibro> libros = (List<DtLibro>) request.getAttribute("libros");
    @SuppressWarnings("unchecked")
    List<DtArticuloEspecial> articulos = (List<DtArticuloEspecial>) request.getAttribute("articulos");
    
    Integer totalLibros = (Integer) request.getAttribute("totalLibros");
    Integer totalArticulos = (Integer) request.getAttribute("totalArticulos");
    Integer totalMateriales = (Integer) request.getAttribute("totalMateriales");
    String error = (String) request.getAttribute("error");
    
    // Datos de trazabilidad (solo para bibliotecarios)
    @SuppressWarnings("unchecked")
    List<DtLibro> librosTrazabilidad = (List<DtLibro>) request.getAttribute("librosTrazabilidad");
    @SuppressWarnings("unchecked")
    List<DtArticuloEspecial> articulosTrazabilidad = (List<DtArticuloEspecial>) request.getAttribute("articulosTrazabilidad");
    
    Integer totalLibrosTrazabilidad = (Integer) request.getAttribute("totalLibrosTrazabilidad");
    Integer totalArticulosTrazabilidad = (Integer) request.getAttribute("totalArticulosTrazabilidad");
    Integer totalDonaciones = (Integer) request.getAttribute("totalDonaciones");
    String fechaDesde = (String) request.getAttribute("fechaDesde");
    String fechaHasta = (String) request.getAttribute("fechaHasta");
    String errorTrazabilidad = (String) request.getAttribute("errorTrazabilidad");
    
    // Inicializar listas vacías si son null
    if (librosTrazabilidad == null) librosTrazabilidad = new java.util.ArrayList<>();
    if (articulosTrazabilidad == null) articulosTrazabilidad = new java.util.ArrayList<>();
    if (totalLibrosTrazabilidad == null) totalLibrosTrazabilidad = 0;
    if (totalArticulosTrazabilidad == null) totalArticulosTrazabilidad = 0;
    if (totalDonaciones == null) totalDonaciones = 0;
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<%!
    // Método helper para convertir XMLGregorianCalendar a String formateado
    private String formatearFecha(XMLGregorianCalendar xmlCalendar) {
        if (xmlCalendar == null) {
            return "N/A";
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            return sdf.format(xmlCalendar.toGregorianCalendar().getTime());
        } catch (Exception e) {
            return "N/A";
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Catálogo de Materiales - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/theme-fixes.css">
    
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
        
        /* Asegurar que los botones no se apilen y tengan espacio suficiente */
        .btn {
            white-space: nowrap;
            min-width: 100px;
            padding: 8px 16px;
            font-size: 14px;
        }
        
        /* Mejorar el contenedor de botones */
        .d-flex.gap-2 {
            gap: 8px !important;
        }
    </style>
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
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarLectores">Lectores</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="ListarMateriales">Materiales</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ListarPrestamos">Préstamos</a>
                    </li>
                    <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="MisPrestamos">Mis Préstamos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="ListarMateriales">Catálogo</a>
                    </li>
                    <% } %>
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
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h2>📖 <%= "BIBLIOTECARIO".equals(rol) ? "Gestión de Materiales" : "Catálogo de Materiales" %></h2>
                        <p class="text-muted">Explora nuestra colección completa</p>
                    </div>
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <div class="d-flex gap-2">
                        <a href="AgregarLibro" class="btn btn-success">
                            ➕ Agregar Libro
                        </a>
                        <a href="AgregarArticuloEspecial" class="btn btn-info text-white">
                            ➕ Agregar Artículo Especial
                        </a>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Mensajes de error -->
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Tabs Navigation (solo para bibliotecarios) -->
        <% if ("BIBLIOTECARIO".equals(rol)) { %>
        <ul class="nav nav-tabs mb-4" id="materialesTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="catalogo-tab" data-bs-toggle="tab" 
                        data-bs-target="#catalogo" type="button" role="tab">
                    📚 Catálogo Completo
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="trazabilidad-tab" data-bs-toggle="tab" 
                        data-bs-target="#trazabilidad" type="button" role="tab">
                    📊 Trazabilidad de Inventario
                </button>
            </li>
        </ul>

        <div class="tab-content" id="materialesTabContent">
            <!-- TAB 1: CATÁLOGO -->
            <div class="tab-pane fade show active" id="catalogo" role="tabpanel">
        <% } %>

                <!-- Búsqueda + Estadísticas -->
                <div class="row mt-3 mb-4">
                    <div class="col-md-8">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <form id="formBusquedaMat" onsubmit="return buscarMateriales()">
                                    <div class="row g-2">
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" id="busquedaMat" placeholder="🔍 Buscar por título o descripción...">
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-primary w-100">Buscar</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h6 class="card-title">📊 Estadísticas del Catálogo</h6>
                                <p class="mb-1"><strong>Total de materiales:</strong> <%= totalMateriales != null ? totalMateriales : 0 %></p>
                                <p class="mb-1"><strong>📚 Libros:</strong> <%= totalLibros != null ? totalLibros : 0 %></p>
                                <p class="mb-0"><strong>🎁 Artículos especiales:</strong> <%= totalArticulos != null ? totalArticulos : 0 %></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sección de Libros -->
                <div class="row mt-4">
                    <div class="col-12">
                        <h3>📚 Libros</h3>
                        <% if (libros != null && !libros.isEmpty()) { %>
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover" id="tablaLibros">
                                        <thead class="table-primary">
                                            <tr>
                                                <th>ID</th>
                                                <th>Título</th>
                                                <th class="text-center">Páginas</th>
                                                <th class="text-center">Fecha Registro</th>
                                                <th class="text-center">Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (DtLibro libro : libros) { %>
                                            <tr>
                                                <td><code><%= libro.getId() %></code></td>
                                                <td><strong><%= new String(libro.getTitulo().getBytes("ISO-8859-1"), "UTF-8") %></strong></td>
                                                <td class="text-center">
                                                    <span class="badge bg-info"><%= libro.getCantidadPaginas() %></span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-success"><%= formatearFecha(libro.getFechaRegistro()) %></span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="btn-group" role="group">
                                                        <a href="ConsultarLibro?id=<%= libro.getId() %>" 
                                                           class="btn btn-sm btn-info text-white" 
                                                           title="Ver detalles">
                                                            👁️ Ver
                                                        </a>
                                                        <% if ("LECTOR".equals(rol)) { %>
                                                        <a href="NuevoPrestamo?materialId=<%= libro.getId() %>&materialTipo=Libro" 
                                                           class="btn btn-sm btn-success" 
                                                           title="Solicitar préstamo">
                                                            📋 Solicitar
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
                        <div class="alert alert-info" role="alert">
                            No hay libros registrados en el catálogo.
                            <% if ("BIBLIOTECARIO".equals(rol)) { %>
                            <a href="AgregarLibro" class="alert-link">¿Agregar el primero?</a>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Sección de Artículos Especiales -->
                <div class="row mt-5">
                    <div class="col-12">
                        <h3>🎁 Artículos Especiales</h3>
                        <% if (articulos != null && !articulos.isEmpty()) { %>
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover" id="tablaArticulos">
                                        <thead class="table-warning">
                                            <tr>
                                                <th>ID</th>
                                                <th>Descripción</th>
                                                <th class="text-center">Peso (kg)</th>
                                                <th class="text-center">Dimensiones</th>
                                                <th class="text-center">Fecha Registro</th>
                                                <th class="text-center">Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (DtArticuloEspecial articulo : articulos) { %>
                                            <tr>
                                                <td><code><%= articulo.getId() %></code></td>
                                                <td><strong><%= new String(articulo.getDescripcion().getBytes("ISO-8859-1"), "UTF-8") %></strong></td>
                                                <td class="text-center">
                                                    <span class="badge bg-warning text-dark"><%= articulo.getPesoKg() %> kg</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-info"><%= articulo.getDimensiones() %></span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-success"><%= formatearFecha(articulo.getFechaRegistro()) %></span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="btn-group" role="group">
                                                        <button type="button" 
                                                                class="btn btn-sm btn-info text-white" 
                                                                onclick="verDetallesArticulo('<%= articulo.getId() %>', '<%= articulo.getDescripcion() %>', '<%= articulo.getPesoKg() %>', '<%= articulo.getDimensiones() %>')"
                                                                title="Ver detalles">
                                                            👁️ Ver
                                                        </button>
                                                        <% if ("LECTOR".equals(rol)) { %>
                                                        <a href="NuevoPrestamo?materialId=<%= articulo.getId() %>&materialTipo=ArticuloEspecial" 
                                                           class="btn btn-sm btn-success" 
                                                           title="Solicitar préstamo">
                                                            📋 Solicitar
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
                        <div class="alert alert-info" role="alert">
                            No hay artículos especiales registrados en el catálogo.
                            <% if ("BIBLIOTECARIO".equals(rol)) { %>
                            <a href="AgregarArticuloEspecial" class="alert-link">¿Agregar el primero?</a>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Botón para refrescar -->
                <div class="row mt-4 mb-5">
                    <div class="col-12 text-center">
                        <button onclick="location.reload()" class="btn btn-outline-secondary">
                            🔄 Actualizar Catálogo
                        </button>
                    </div>
                </div>

        <% if ("BIBLIOTECARIO".equals(rol)) { %>
            </div><!-- Fin tab catálogo -->

            <!-- TAB 2: TRAZABILIDAD -->
            <div class="tab-pane fade" id="trazabilidad" role="tabpanel">
                
                <% if (errorTrazabilidad != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error:</strong> <%= errorTrazabilidad %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <!-- Filtros de fecha -->
                <div class="row mt-3 mb-4">
                    <div class="col-md-8">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">🔍 Filtrar Donaciones por Fecha</h5>
                                <form method="get" action="ListarMateriales">
                                    <input type="hidden" name="showTab" value="trazabilidad">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label for="fechaDesde" class="form-label">Fecha Desde:</label>
                                            <input type="date" class="form-control" id="fechaDesde" name="fechaDesde" 
                                                   value="<%= fechaDesde != null ? fechaDesde : "" %>">
                                        </div>
                                        <div class="col-md-4">
                                            <label for="fechaHasta" class="form-label">Fecha Hasta:</label>
                                            <input type="date" class="form-control" id="fechaHasta" name="fechaHasta" 
                                                   value="<%= fechaHasta != null ? fechaHasta : "" %>">
                                        </div>
                                        <div class="col-md-4 d-flex align-items-end gap-2">
                                            <button type="submit" class="btn btn-success" style="flex: 1;">
                                                🔍 Consultar
                                            </button>
                                            <a href="ListarMateriales" class="btn btn-outline-secondary" style="flex: 1;">
                                                🔄 Limpiar
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
                                <h6 class="card-title">📊 Estadísticas de Donaciones</h6>
                                <p class="mb-1"><strong>Total Libros:</strong> <%= totalLibrosTrazabilidad %></p>
                                <p class="mb-1"><strong>Total Artículos:</strong> <%= totalArticulosTrazabilidad %></p>
                                <p class="mb-0"><strong>Total Donaciones:</strong> <span class="badge bg-success"><%= totalDonaciones %></span></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Información del filtro aplicado -->
                <% if (fechaDesde != null || fechaHasta != null) { %>
                <div class="row mb-3">
                    <div class="col-12">
                        <div class="alert alert-info">
                            <strong>Filtro aplicado:</strong>
                            <% if (fechaDesde != null && fechaHasta != null) { %>
                                Desde <%= fechaDesde %> hasta <%= fechaHasta %>
                            <% } else if (fechaDesde != null) { %>
                                Desde <%= fechaDesde %>
                            <% } else if (fechaHasta != null) { %>
                                Hasta <%= fechaHasta %>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Tabla de Libros Donados -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h4>📚 Libros Donados</h4>
                        <% if (librosTrazabilidad != null && !librosTrazabilidad.isEmpty()) { %>
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-success">
                                            <tr>
                                                <th style="width: 15%;">ID Material</th>
                                                <th style="width: 45%;">Título</th>
                                                <th class="text-center" style="width: 15%;">Páginas</th>
                                                <th class="text-center" style="width: 25%;">Fecha Donación</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (DtLibro libro : librosTrazabilidad) { %>
                                            <tr>
                                                <td><code><%= libro.getId() %></code></td>
                                                <td><strong><%= new String(libro.getTitulo().getBytes("ISO-8859-1"), "UTF-8") %></strong></td>
                                                <td class="text-center"><%= libro.getCantidadPaginas() %></td>
                                                <td class="text-center">
                                                    <span class="badge bg-info">
                                                        <%= formatearFecha(libro.getFechaRegistro()) %>
                                                    </span>
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
                            <div class="card-body text-center py-4">
                                <div class="mb-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-book text-muted" viewBox="0 0 16 16">
                                        <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811V2.828zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492V2.687zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783z"/>
                                    </svg>
                                </div>
                                <h5 class="text-muted">No hay libros en este rango de fechas</h5>
                                <p class="text-muted mb-0">Intenta con otro rango de fechas</p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Tabla de Artículos Especiales Donados -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h4>🎨 Artículos Especiales Donados</h4>
                        <% if (articulosTrazabilidad != null && !articulosTrazabilidad.isEmpty()) { %>
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-success">
                                            <tr>
                                                <th style="width: 15%;">ID Material</th>
                                                <th style="width: 30%;">Descripción</th>
                                                <th class="text-center" style="width: 15%;">Peso (kg)</th>
                                                <th class="text-center" style="width: 15%;">Dimensiones</th>
                                                <th class="text-center" style="width: 25%;">Fecha Donación</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (DtArticuloEspecial articulo : articulosTrazabilidad) { %>
                                            <tr>
                                                <td><code><%= articulo.getId() %></code></td>
                                                <td><strong><%= new String(articulo.getDescripcion().getBytes("ISO-8859-1"), "UTF-8") %></strong></td>
                                                <td class="text-center"><%= articulo.getPesoKg() %> kg</td>
                                                <td class="text-center"><%= articulo.getDimensiones() %></td>
                                                <td class="text-center">
                                                    <span class="badge bg-info">
                                                        <%= formatearFecha(articulo.getFechaRegistro()) %>
                                                    </span>
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
                            <div class="card-body text-center py-4">
                                <div class="mb-3">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor" class="bi bi-box text-muted" viewBox="0 0 16 16">
                                        <path d="M8.186 1.113a.5.5 0 0 0-.372 0L1.846 3.5 8 5.961 14.154 3.5 8.186 1.113zM15 4.239l-6.5 2.6v7.922l6.5-2.6V4.24zM7.5 14.762V6.838L1 4.239v7.923l6.5 2.6zM7.443.184a1.5 1.5 0 0 1 1.114 0l7.129 2.852A.5.5 0 0 1 16 3.5v8.662a1 1 0 0 1-.629.928l-7.185 2.874a.5.5 0 0 1-.372 0L.63 13.09a1 1 0 0 1-.63-.928V3.5a.5.5 0 0 1 .314-.464L7.443.184z"/>
                                    </svg>
                                </div>
                                <h5 class="text-muted">No hay artículos especiales en este rango de fechas</h5>
                                <p class="text-muted mb-0">Intenta con otro rango de fechas</p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Botón para refrescar -->
                <div class="row mt-4 mb-4">
                    <div class="col-12 text-center">
                        <a href="ListarMateriales" class="btn btn-outline-secondary">
                            🔄 Ver Todas las Donaciones
                        </a>
                    </div>
                </div>

            </div><!-- Fin tab trazabilidad -->
        </div><!-- Fin tab content -->
        <% } %>
    </div>

    <!-- Modal para ver detalles de artículo especial -->
    <div class="modal fade" id="detallesArticuloModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">📦 Detalles del Artículo Especial</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><strong>ID:</strong> <code id="modalArticuloId"></code></p>
                    <p><strong>Descripción:</strong> <span id="modalArticuloDescripcion"></span></p>
                    <p><strong>Peso:</strong> <span id="modalArticuloPeso"></span> kg</p>
                    <p><strong>Dimensiones:</strong> <span id="modalArticuloDimensiones"></span></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
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
        function buscarMateriales() {
            const q = document.getElementById('busquedaMat').value.toLowerCase().trim();
            // Filtra filas de ambas tablas (libros y artículos)
            const filas = document.querySelectorAll('#tablaLibros tbody tr, #tablaArticulos tbody tr');
            let encontrados = 0;
            filas.forEach(f => {
                const columnas = f.querySelectorAll('td');
                const texto = Array.from(columnas).map(td => td.textContent.toLowerCase()).join(' ');
                if (!q || texto.includes(q)) { f.style.display = ''; encontrados++; }
                else { f.style.display = 'none'; }
            });
            if (q && encontrados === 0) {
                alert('Sin resultados para: \'' + q + '\'');
            }
            return false;
        }
        
        function verDetallesArticulo(id, descripcion, peso, dimensiones) {
            document.getElementById('modalArticuloId').textContent = id;
            document.getElementById('modalArticuloDescripcion').textContent = descripcion;
            document.getElementById('modalArticuloPeso').textContent = peso;
            document.getElementById('modalArticuloDimensiones').textContent = dimensiones;
            
            const modal = new bootstrap.Modal(document.getElementById('detallesArticuloModal'));
            modal.show();
        }
        
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Si hay parámetro showTab=trazabilidad, activar ese tab
        <% if ("trazabilidad".equals(request.getParameter("showTab")) || fechaDesde != null || fechaHasta != null) { %>
        document.addEventListener('DOMContentLoaded', function() {
            const trazabilidadTab = new bootstrap.Tab(document.getElementById('trazabilidad-tab'));
            trazabilidadTab.show();
        });
        <% } %>
    </script>
    
</body>
</html>
