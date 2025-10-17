<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="publicadores.libro.DtLibro" %>
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
    DtLibro libro = (DtLibro) request.getAttribute("libro");
    String error = (String) request.getAttribute("error");
    
    if (libro == null) {
        response.sendRedirect("ListarLibros?error=libro_no_encontrado");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Editar Libro - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="ListarLibros">Catálogo</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="AgregarLibro">Agregar Libro</a>
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
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="home.jsp">Inicio</a></li>
                        <li class="breadcrumb-item"><a href="ListarLibros">Catálogo</a></li>
                        <li class="breadcrumb-item"><a href="ConsultarLibro?id=<%= libro.getId() %>">Detalle</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Editar</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-warning">
                        <h4 class="mb-0">✏️ Editar Libro</h4>
                    </div>
                    <div class="card-body">
                        <% if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error:</strong> <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                        
                        <div class="alert alert-info" role="alert">
                            <strong>ID del Libro:</strong> <code><%= libro.getId() %></code>
                        </div>
                        
                        <form action="ModificarLibro" method="post" onsubmit="return validarFormulario()">
                            <input type="hidden" name="id" value="<%= libro.getId() %>">
                            
                            <div class="mb-3">
                                <label for="titulo" class="form-label">Título del Libro *</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="titulo" 
                                       name="titulo" 
                                       placeholder="Ingrese el título del libro"
                                       value="<%= libro.getTitulo() %>"
                                       required>
                                <div class="form-text">Modifica el título del libro</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="cantidadPaginas" class="form-label">Cantidad de Páginas *</label>
                                <input type="number" 
                                       class="form-control" 
                                       id="cantidadPaginas" 
                                       name="cantidadPaginas" 
                                       placeholder="Ej: 250"
                                       value="<%= libro.getCantidadPaginas() %>"
                                       min="1"
                                       required>
                                <div class="form-text">Debe ser un número entero positivo</div>
                            </div>
                            
                            <div class="alert alert-warning" role="alert">
                                <small>
                                    <strong>⚠️ Advertencia:</strong> Los cambios se aplicarán inmediatamente y afectarán todos los registros relacionados.
                                </small>
                            </div>
                            
                            <div class="d-flex gap-2 justify-content-between">
                                <a href="ConsultarLibro?id=<%= libro.getId() %>" class="btn btn-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-warning">
                                    💾 Guardar Cambios
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Comparación de cambios -->
                <div class="card shadow-sm mt-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0">📋 Datos Actuales</h6>
                    </div>
                    <div class="card-body">
                        <table class="table table-sm table-borderless mb-0">
                            <tr>
                                <th>Título Original:</th>
                                <td><%= libro.getTitulo() %></td>
                            </tr>
                            <tr>
                                <th>Páginas Actuales:</th>
                                <td><%= libro.getCantidadPaginas() %></td>
                            </tr>
                        </table>
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
        function validarFormulario() {
            const titulo = document.getElementById('titulo').value.trim();
            const paginas = document.getElementById('cantidadPaginas').value;
            
            if (titulo === '') {
                alert('El título es obligatorio');
                return false;
            }
            
            if (paginas <= 0) {
                alert('La cantidad de páginas debe ser mayor a 0');
                return false;
            }
            
            // Confirmar cambios
            return confirm('¿Estás seguro de que deseas guardar estos cambios?');
        }
    </script>
</body>
</html>

