<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.libro.DtLibro" %>
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
    Integer totalLibros = (Integer) request.getAttribute("totalLibros");
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
    String info = request.getParameter("info");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Catálogo - Biblioteca Comunitaria</title>
    
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
                        <h2>📖 Catálogo de Libros</h2>
                        <p class="text-light">Explora nuestra colección de libros</p>
                    </div>
                    <% if ("BIBLIOTECARIO".equals(rol)) { %>
                    <div>
                        <a href="AgregarLibro" class="btn btn-success">
                            ➕ Agregar Nuevo Libro
                        </a>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Mensajes de feedback -->
        <% if ("agregar".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> El libro ha sido agregado correctamente al catálogo.
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
                        <form id="formBusqueda" onsubmit="return buscarLibros()">
                            <div class="row g-2">
                                <div class="col-md-8">
                                    <input type="text" 
                                           class="form-control" 
                                           id="busqueda" 
                                           placeholder="🔍 Buscar por título...">
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
                        <p class="mb-1"><strong>Total de libros:</strong> <%= totalLibros != null ? totalLibros : 0 %></p>
                        <p class="mb-0"><strong>Mostrando:</strong> <%= libros != null ? libros.size() : 0 %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista de libros -->
        <div class="row">
            <div class="col-12">
                <% if (libros != null && !libros.isEmpty()) { %>
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-<%= "BIBLIOTECARIO".equals(rol) ? "success" : "primary" %>">
                                    <tr>
                                        <th style="width: 15%;">ID</th>
                                        <th style="width: 45%;">Título</th>
                                        <th class="text-center" style="width: 15%;">Páginas</th>
                                        <th class="text-center" style="width: 25%;">Fecha Registro</th>
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
                                                    
                                                    // Debug: mostrar información de la fecha
                                                    System.out.println("Fecha original: " + fechaString);
                                                    System.out.println("Tipo: " + fechaObj.getClass().getName());
                                                    
                                                    // Si contiene formato ISO con T, extraer solo la fecha
                                                    if (fechaString.contains("T")) {
                                                        // Extraer solo la parte de la fecha (antes de la T)
                                                        String soloFecha = fechaString.split("T")[0];
                                                        // Dividir por guiones y reorganizar
                                                        String[] partes = soloFecha.split("-");
                                                        if (partes.length == 3) {
                                                            fechaStr = partes[2] + "/" + partes[1] + "/" + partes[0];
                                                        } else {
                                                            fechaStr = soloFecha;
                                                        }
                                                    } else if (fechaString.contains("-")) {
                                                        // Formato yyyy-MM-dd
                                                        String[] partes = fechaString.split("-");
                                                        if (partes.length == 3) {
                                                            fechaStr = partes[2] + "/" + partes[1] + "/" + partes[0];
                                                        } else {
                                                            fechaStr = fechaString;
                                                        }
                                                    } else {
                                                        // Intentar formatear como fecha normal
                                                        try {
                                                            java.util.Date fecha = sdf.parse(fechaString);
                                                            fechaStr = sdf.format(fecha);
                                                        } catch (Exception parseEx) {
                                                            fechaStr = fechaString;
                                                        }
                                                    }
                                                    
                                                    System.out.println("Fecha formateada: " + fechaStr);
                                            %>
                                                <span class="badge bg-success"><%= fechaStr %></span>
                                            <% 
                                                } else {
                                            %>
                                                <span class="badge bg-secondary">Sin fecha</span>
                                            <% 
                                                }
                                            } catch (Exception e) {
                                                // Mostrar información de debug
                                                System.out.println("Error al formatear fecha: " + e.getMessage());
                                                System.out.println("Tipo de fecha: " + (libro.getFechaRegistro() != null ? libro.getFechaRegistro().getClass().getName() : "null"));
                                                e.printStackTrace();
                                            %>
                                                <span class="badge bg-warning" title="Error: <%= e.getMessage() %>">Error</span>
                                            <%
                                            }
                                            %>
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
                        <h5 class="text-muted">No hay libros en el catálogo</h5>
                        <p class="text-muted mb-3">Aún no se han registrado libros en el sistema</p>
                        <% if ("BIBLIOTECARIO".equals(rol)) { %>
                        <a href="AgregarLibro" class="btn btn-success">
                            ➕ Agregar el Primer Libro
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
        function buscarLibros() {
            const busqueda = document.getElementById('busqueda').value.toLowerCase().trim();
            
            if (busqueda === '') {
                // Recargar la página para mostrar todos los libros
                window.location.href = 'ListarLibros';
                return false;
            }
            
            // Filtrar libros en el cliente (simple implementación)
            const filas = document.querySelectorAll('tbody tr');
            let encontrados = 0;
            
            filas.forEach(fila => {
                const titulo = fila.querySelector('td:nth-child(2)').textContent.toLowerCase();
                if (titulo.includes(busqueda)) {
                    fila.style.display = '';
                    encontrados++;
                } else {
                    fila.style.display = 'none';
                }
            });
            
            // Mostrar mensaje si no hay resultados
            if (encontrados === 0) {
                alert('No se encontraron libros que coincidan con: "' + busqueda + '"');
            }
            
            return false; // Evitar envío del formulario
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
