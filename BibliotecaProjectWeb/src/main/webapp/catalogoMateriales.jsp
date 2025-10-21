<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.libro.DtLibro" %>
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
    List<DtLibro> libros = (List<DtLibro>) request.getAttribute("libros");
    @SuppressWarnings("unchecked")
    List<DtArticuloEspecial> articulos = (List<DtArticuloEspecial>) request.getAttribute("articulos");
    
    Integer totalLibros = (Integer) request.getAttribute("totalLibros");
    Integer totalArticulos = (Integer) request.getAttribute("totalArticulos");
    Integer totalMateriales = (Integer) request.getAttribute("totalMateriales");
    String error = (String) request.getAttribute("error");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
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
                        <a class="nav-link active" href="ListarMateriales">Catálogo</a>
                    </li>
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            Agregar Material
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="AgregarLibro">📚 Agregar Libro</a></li>
                            <li><a class="dropdown-item" href="AgregarArticuloEspecial">🎁 Agregar Artículo Especial</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="TrazabilidadInventario">📊 Trazabilidad</a>
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
                        <h2>📖 Catálogo de Materiales</h2>
                        <p class="text-muted">Explora nuestra colección completa</p>
                    </div>
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
                            <table class="table table-hover">
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
                                            <% 
                                            try {
                                                Object fechaObj = libro.getFechaRegistro();
                                                if (fechaObj != null) {
                                                    String fechaStr = "";
                                                    String fechaString = fechaObj.toString();
                                                    
                                                    // Si contiene formato ISO con T, extraer solo la fecha
                                                    if (fechaString.contains("T")) {
                                                        String soloFecha = fechaString.split("T")[0];
                                                        String[] partes = soloFecha.split("-");
                                                        if (partes.length == 3) {
                                                            fechaStr = partes[2] + "/" + partes[1] + "/" + partes[0];
                                                        } else {
                                                            fechaStr = soloFecha;
                                                        }
                                                    } else if (fechaString.contains("-")) {
                                                        String[] partes = fechaString.split("-");
                                                        if (partes.length == 3) {
                                                            fechaStr = partes[2] + "/" + partes[1] + "/" + partes[0];
                                                        } else {
                                                            fechaStr = fechaString;
                                                        }
                                                    } else {
                                                        try {
                                                            java.util.Date fecha = sdf.parse(fechaString);
                                                            fechaStr = sdf.format(fecha);
                                                        } catch (Exception parseEx) {
                                                            fechaStr = fechaString;
                                                        }
                                                    }
                                            %>
                                                <span class="badge bg-success"><%= fechaStr %></span>
                                            <% 
                                                } else {
                                            %>
                                                <span class="badge bg-secondary">Sin fecha</span>
                                            <% 
                                                }
                                            } catch (Exception e) {
                                            %>
                                                <span class="badge bg-warning">Error</span>
                                            <%
                                            }
                                            %>
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
                            <table class="table table-hover">
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
                                            <% 
                                            try {
                                                Object fechaObj = articulo.getFechaRegistro();
                                                if (fechaObj != null) {
                                                    String fechaStr = "";
                                                    String fechaString = fechaObj.toString();
                                                    
                                                    // Si contiene formato ISO con T, extraer solo la fecha
                                                    if (fechaString.contains("T")) {
                                                        String soloFecha = fechaString.split("T")[0];
                                                        String[] partes = soloFecha.split("-");
                                                        if (partes.length == 3) {
                                                            fechaStr = partes[2] + "/" + partes[1] + "/" + partes[0];
                                                        } else {
                                                            fechaStr = soloFecha;
                                                        }
                                                    } else if (fechaString.contains("-")) {
                                                        String[] partes = fechaString.split("-");
                                                        if (partes.length == 3) {
                                                            fechaStr = partes[2] + "/" + partes[1] + "/" + partes[0];
                                                        } else {
                                                            fechaStr = fechaString;
                                                        }
                                                    } else {
                                                        try {
                                                            java.util.Date fecha = sdf.parse(fechaString);
                                                            fechaStr = sdf.format(fecha);
                                                        } catch (Exception parseEx) {
                                                            fechaStr = fechaString;
                                                        }
                                                    }
                                            %>
                                                <span class="badge bg-success"><%= fechaStr %></span>
                                            <% 
                                                } else {
                                            %>
                                                <span class="badge bg-secondary">Sin fecha</span>
                                            <% 
                                                }
                                            } catch (Exception e) {
                                            %>
                                                <span class="badge bg-warning">Error</span>
                                            <%
                                            }
                                            %>
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
            const filas = document.querySelectorAll('tbody tr');
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
    </script>
</body>
</html>

