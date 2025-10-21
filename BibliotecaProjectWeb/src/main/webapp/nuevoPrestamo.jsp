<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.libro.DtLibro" %>
<%@ page import="publicadores.articuloespecial.DtArticuloEspecial" %>
<%@ page import="java.util.List" %>
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
    List<DtLibro> libros = (List<DtLibro>) request.getAttribute("libros");
    @SuppressWarnings("unchecked")
    List<DtArticuloEspecial> articulos = (List<DtArticuloEspecial>) request.getAttribute("articulos");
    String materialIdPreseleccionado = (String) request.getAttribute("materialIdPreseleccionado");
    String materialTipoPreseleccionado = (String) request.getAttribute("materialTipoPreseleccionado");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Solicitar Préstamo - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="MisPrestamos">Mis Préstamos</a>
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
                        <h2>➕ Solicitar Nuevo Préstamo</h2>
                        <p class="text-light">Selecciona el material que deseas solicitar</p>
                    </div>
                    <div>
                        <a href="MisPrestamos" class="btn btn-secondary">
                            ⬅️ Volver a Mis Préstamos
                        </a>
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

        <!-- Formulario de solicitud -->
        <div class="row">
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">📚 Seleccionar Material</h5>
                    </div>
                    <div class="card-body">
                        <form action="NuevoPrestamo" method="post" onsubmit="return validarSeleccion()">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Material Disponible *</label>
                                
                                <!-- Pestañas para libros y artículos -->
                                <ul class="nav nav-tabs" id="materialTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="libros-tab" data-bs-toggle="tab" 
                                                data-bs-target="#libros" type="button" role="tab">
                                            📖 Libros (<%= libros != null ? libros.size() : 0 %>)
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="articulos-tab" data-bs-toggle="tab" 
                                                data-bs-target="#articulos" type="button" role="tab">
                                            🎁 Artículos Especiales (<%= articulos != null ? articulos.size() : 0 %>)
                                        </button>
                                    </li>
                                </ul>
                                
                                <div class="tab-content mt-3" id="materialTabsContent">
                                    <!-- Tab de Libros (Dropdown) -->
                                    <div class="tab-pane fade show active" id="libros" role="tabpanel">
                                        <% if (libros != null && !libros.isEmpty()) { %>
                                        <div class="mb-3">
                                            <label for="selectLibro" class="form-label fw-bold">Seleccionar Libro</label>
                                            <select class="form-select" id="selectLibro">
                                                <option value="">-- Selecciona un libro --</option>
                                                <% for (DtLibro libro : libros) { 
                                                     String titulo = new String(libro.getTitulo().getBytes("ISO-8859-1"), "UTF-8");
                                                     boolean selected = (materialIdPreseleccionado != null && materialIdPreseleccionado.equals(libro.getId())
                                                                         && "Libro".equals(materialTipoPreseleccionado));
                                                %>
                                                  <option value="<%= libro.getId() %>" <%= selected ? "selected" : "" %>>
                                                    <%= titulo %> | <%= libro.getCantidadPaginas() %> páginas
                                                  </option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <% } else { %>
                                        <div class="text-center py-4">
                                            <p class="text-muted">No hay libros disponibles</p>
                                        </div>
                                        <% } %>
                                    </div>
                                    
                                    <!-- Tab de Artículos Especiales (Dropdown) -->
                                    <div class="tab-pane fade" id="articulos" role="tabpanel">
                                        <% if (articulos != null && !articulos.isEmpty()) { %>
                                        <div class="mb-3">
                                            <label for="selectArticulo" class="form-label fw-bold">Seleccionar Artículo Especial</label>
                                            <select class="form-select" id="selectArticulo">
                                                <option value="">-- Selecciona un artículo especial --</option>
                                                <% for (DtArticuloEspecial articulo : articulos) { 
                                                     String desc = new String(articulo.getDescripcion().getBytes("ISO-8859-1"), "UTF-8");
                                                     boolean selected = (materialIdPreseleccionado != null && materialIdPreseleccionado.equals(articulo.getId())
                                                                         && "ArticuloEspecial".equals(materialTipoPreseleccionado));
                                                %>
                                                  <option value="<%= articulo.getId() %>" <%= selected ? "selected" : "" %>>
                                                    <%= desc %> | <%= articulo.getPesoKg() %> kg | <%= articulo.getDimensiones() %>
                                                  </option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <% } else { %>
                                        <div class="text-center py-4">
                                            <p class="text-muted">No hay artículos especiales disponibles</p>
                                        </div>
                                        <% } %>
                                    </div>
                                </div>
                                
                                <!-- Campos ocultos para enviar al servidor -->
                                <input type="hidden" id="materialId" name="materialId" value="<%= materialIdPreseleccionado != null ? materialIdPreseleccionado : "" %>">
                                <input type="hidden" id="materialTipo" name="materialTipo" value="<%= materialTipoPreseleccionado != null ? materialTipoPreseleccionado : "" %>">
                            </div>
                            
                            <div class="alert alert-info" role="alert">
                                <h6 class="alert-heading">ℹ️ Información Importante</h6>
                                <ul class="mb-0">
                                    <li>Selecciona un material de la lista disponible</li>
                                    <li>Tu solicitud será revisada por un bibliotecario</li>
                                    <li>Recibirás una notificación cuando sea aprobada</li>
                                </ul>
                            </div>
                            
                            <div class="d-flex gap-2 justify-content-end">
                                <a href="MisPrestamos" class="btn btn-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    ✅ Solicitar Préstamo
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Panel de información -->
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">ℹ️ Información del Préstamo</h6>
                    </div>
                    <div class="card-body">
                        <h6>Proceso de Solicitud:</h6>
                        <ol class="small">
                            <li><strong>Solicitud:</strong> Selecciona el material</li>
                            <li><strong>Revisión:</strong> Un bibliotecario revisa tu solicitud</li>
                            <li><strong>Aprobación:</strong> Si es aprobada, puedes retirar el material</li>
                            <li><strong>Uso:</strong> Disfruta del material prestado</li>
                            <li><strong>Devolución:</strong> Devuelve el material en tiempo</li>
                        </ol>
                        
                        <hr>
                        
                        <h6>Estados del Préstamo:</h6>
                        <div class="small">
                            <span class="badge bg-primary me-1">⏳ Solicitado</span>
                            <span class="badge bg-success me-1">✅ Aprobado</span>
                            <span class="badge bg-warning me-1">📖 En Uso</span>
                            <span class="badge bg-secondary me-1">📚 Devuelto</span>
                        </div>
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
        // Preseleccionar material si viene desde el catálogo
        document.addEventListener('DOMContentLoaded', function() {
            const materialIdPreseleccionado = '<%= materialIdPreseleccionado != null ? materialIdPreseleccionado : "" %>';
            const materialTipoPreseleccionado = '<%= materialTipoPreseleccionado != null ? materialTipoPreseleccionado : "" %>';
            
            const selectLibro = document.getElementById('selectLibro');
            const selectArticulo = document.getElementById('selectArticulo');
            const hiddenMaterialId = document.getElementById('materialId');
            const hiddenMaterialTipo = document.getElementById('materialTipo');
            
            // Event listener para el dropdown de libros
            if (selectLibro) {
                selectLibro.addEventListener('change', function() {
                    if (this.value) {
                        hiddenMaterialId.value = this.value;
                        hiddenMaterialTipo.value = 'Libro';
                        // Limpiar selección de artículos
                        if (selectArticulo) selectArticulo.value = '';
                    } else {
                        hiddenMaterialId.value = '';
                        hiddenMaterialTipo.value = '';
                    }
                });
                
                // Preseleccionar si viene desde catálogo
                if (materialTipoPreseleccionado === 'Libro' && materialIdPreseleccionado) {
                    selectLibro.value = materialIdPreseleccionado;
                    hiddenMaterialId.value = materialIdPreseleccionado;
                    hiddenMaterialTipo.value = 'Libro';
                }
            }
            
            // Event listener para el dropdown de artículos
            if (selectArticulo) {
                selectArticulo.addEventListener('change', function() {
                    if (this.value) {
                        hiddenMaterialId.value = this.value;
                        hiddenMaterialTipo.value = 'ArticuloEspecial';
                        // Limpiar selección de libros
                        if (selectLibro) selectLibro.value = '';
                    } else {
                        hiddenMaterialId.value = '';
                        hiddenMaterialTipo.value = '';
                    }
                });
                
                // Preseleccionar si viene desde catálogo
                if (materialTipoPreseleccionado === 'ArticuloEspecial' && materialIdPreseleccionado) {
                    selectArticulo.value = materialIdPreseleccionado;
                    hiddenMaterialId.value = materialIdPreseleccionado;
                    hiddenMaterialTipo.value = 'ArticuloEspecial';
                }
            }

            // Cambiar pestaña si viene preseleccionado desde catálogo
            if (materialIdPreseleccionado && materialTipoPreseleccionado) {
                if (materialTipoPreseleccionado === 'Libro') {
                    document.getElementById('libros-tab').click();
                } else if (materialTipoPreseleccionado === 'ArticuloEspecial') {
                    document.getElementById('articulos-tab').click();
                }
            }
        });
        
        
        function validarSeleccion() {
            const hiddenMaterialId = document.getElementById('materialId');
            const hiddenMaterialTipo = document.getElementById('materialTipo');
            
            // Verificar que se haya seleccionado un material
            if (!hiddenMaterialId.value || !hiddenMaterialTipo.value) {
                alert('Por favor selecciona un material para solicitar el préstamo');
                return false;
            }
            
            // Obtener el texto descriptivo del material seleccionado
            let materialTexto = '';
            const selectLibro = document.getElementById('selectLibro');
            const selectArticulo = document.getElementById('selectArticulo');
            
            if (hiddenMaterialTipo.value === 'Libro' && selectLibro && selectLibro.value) {
                materialTexto = selectLibro.options[selectLibro.selectedIndex].text;
            } else if (hiddenMaterialTipo.value === 'ArticuloEspecial' && selectArticulo && selectArticulo.value) {
                materialTexto = selectArticulo.options[selectArticulo.selectedIndex].text;
            } else {
                materialTexto = 'Material ID: ' + hiddenMaterialId.value;
            }
            
            const confirmacion = confirm(
                '¿Está seguro de solicitar el préstamo de este material?\n\n' +
                'Material: ' + materialTexto + '\n' +
                'Tipo: ' + (hiddenMaterialTipo.value === 'Libro' ? 'Libro' : 'Artículo Especial')
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
