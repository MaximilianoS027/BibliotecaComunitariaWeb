<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.articuloespecial.DtArticuloEspecial" %>
<%@ page import="java.util.List" %>
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
    
    @SuppressWarnings("unchecked")
    List<DtArticuloEspecial> articulos = (List<DtArticuloEspecial>) request.getAttribute("articulos");
    Integer totalArticulos = (Integer) request.getAttribute("totalArticulos");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Catálogo Artículos Especiales - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="ListarLibros">Libros</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="ListarArticulosEspeciales">Artículos Especiales</a>
                    </li>
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="AgregarArticuloEspecial">Agregar Artículo Especial</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="TrazabilidadInventario">📊 Trazabilidad</a>
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
                        <h2>🎁 Catálogo de Artículos Especiales</h2>
                        <p class="text-muted">Materiales especiales disponibles para préstamo</p>
                    </div>
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <div>
                        <a href="AgregarArticuloEspecial" class="btn btn-success">
                            ➕ Agregar Nuevo Artículo Especial
                        </a>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Mensajes de feedback -->
        <% if ("agregar".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> El artículo especial ha sido agregado correctamente al catálogo.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <!-- Barra de búsqueda y filtros -->
        <div class="row mt-3 mb-4">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <form id="formBusqueda" onsubmit="return buscarArticulos()">
                            <div class="row g-2">
                                <div class="col-md-8">
                                    <input type="text" 
                                           class="form-control" 
                                           id="busqueda" 
                                           placeholder="🔍 Buscar por descripción...">
                                </div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary w-100">
                                        Buscar
                                    </button>
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
                        <p class="mb-1"><strong>Total de artículos:</strong> <%= totalArticulos != null ? totalArticulos : 0 %></p>
                        <p class="mb-0"><strong>Mostrando:</strong> <%= articulos != null ? articulos.size() : 0 %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista de artículos especiales -->
        <div class="row">
            <div class="col-12">
                <% if (articulos != null && !articulos.isEmpty()) { %>
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-<%= "BIBLIOTECARIO".equals(rol) ? "success" : "primary" %>">
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
                                        <td><strong><%= articulo.getDescripcion() %></strong></td>
                                        <td class="text-center">
                                            <span class="badge bg-warning text-dark"><%= articulo.getPesoKg() %> kg</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-info"><%= articulo.getDimensiones() %></span>
                                        </td>
                                        <td class="text-center">
                                            <% 
                                            try {
                                                if (articulo.getFechaRegistro() != null) { 
                                            %>
                                                <%= sdf.format(articulo.getFechaRegistro()) %>
                                            <% 
                                                } else {
                                            %>
                                                -
                                            <% 
                                                }
                                            } catch (Exception e) {
                                            %>
                                                -
                                            <%
                                            }
                                            %>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <button type="button" 
                                                        class="btn btn-sm btn-info text-white" 
                                                        onclick="verDetalles('<%= articulo.getId() %>', '<%= articulo.getDescripcion() %>', '<%= articulo.getPesoKg() %>', '<%= articulo.getDimensiones() %>')"
                                                        title="Ver detalles">
                                                    👁️
                                                </button>
                                                <% if ("LECTOR".equals(rol)) { %>
                                                <button type="button" 
                                                        class="btn btn-sm btn-success" 
                                                        title="Solicitar préstamo">
                                                    📋 Solicitar
                                                </button>
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
                            <span style="font-size: 64px;">🎁</span>
                        </div>
                        <h5 class="text-muted">No hay artículos especiales en el catálogo</h5>
                        <p class="text-muted mb-3">Aún no se han registrado artículos especiales en el sistema</p>
                        <% if ("BIBLIOTECARIO".equals(rol)) { %>
                        <a href="AgregarArticuloEspecial" class="btn btn-success">
                            ➕ Agregar el Primer Artículo Especial
                        </a>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Botón para refrescar -->
        <div class="row mt-3">
            <div class="col-12 text-center">
                <button onclick="location.reload()" class="btn btn-outline-secondary">
                    🔄 Actualizar Catálogo
                </button>
            </div>
        </div>
    </div>

    <!-- Modal para ver detalles -->
    <div class="modal fade" id="detallesModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">📦 Detalles del Artículo Especial</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><strong>ID:</strong> <code id="modalId"></code></p>
                    <p><strong>Descripción:</strong> <span id="modalDescripcion"></span></p>
                    <p><strong>Peso:</strong> <span id="modalPeso"></span> kg</p>
                    <p><strong>Dimensiones:</strong> <span id="modalDimensiones"></span></p>
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
        function buscarArticulos() {
            const busqueda = document.getElementById('busqueda').value.toLowerCase().trim();
            
            if (busqueda === '') {
                window.location.href = 'ListarArticulosEspeciales';
                return false;
            }
            
            const filas = document.querySelectorAll('tbody tr');
            let encontrados = 0;
            
            filas.forEach(fila => {
                const descripcion = fila.querySelector('td:nth-child(2)').textContent.toLowerCase();
                if (descripcion.includes(busqueda)) {
                    fila.style.display = '';
                    encontrados++;
                } else {
                    fila.style.display = 'none';
                }
            });
            
            if (encontrados === 0) {
                alert('No se encontraron artículos que coincidan con: "' + busqueda + '"');
            }
            
            return false;
        }
        
        function verDetalles(id, descripcion, peso, dimensiones) {
            document.getElementById('modalId').textContent = id;
            document.getElementById('modalDescripcion').textContent = descripcion;
            document.getElementById('modalPeso').textContent = peso;
            document.getElementById('modalDimensiones').textContent = dimensiones;
            
            const modal = new bootstrap.Modal(document.getElementById('detallesModal'));
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
    </script>
</body>
</html>

