<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    String error = (String) request.getAttribute("error");
    String titulo = (String) request.getAttribute("titulo");
    String cantidadPaginas = (String) request.getAttribute("cantidadPaginas");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Agregar Libro - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link active" href="ListarMateriales">Materiales</a>
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
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">📖 Registrar Nuevo Libro</h4>
                    </div>
                    <div class="card-body">
                        <% if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error:</strong> <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                        
                        <form action="AgregarLibro" method="post" onsubmit="return validarFormulario()">
                            <div class="mb-3">
                                <label for="titulo" class="form-label">Título del Libro *</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="titulo" 
                                       name="titulo" 
                                       placeholder="Ingrese el título del libro"
                                       value="<%= titulo != null ? titulo : "" %>"
                                       required>
                                <div class="form-text">El título debe ser único en el sistema</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="cantidadPaginas" class="form-label">Cantidad de Páginas *</label>
                                <input type="number" 
                                       class="form-control" 
                                       id="cantidadPaginas" 
                                       name="cantidadPaginas" 
                                       placeholder="Ej: 250"
                                       value="<%= cantidadPaginas != null ? cantidadPaginas : "" %>"
                                       min="1"
                                       required>
                                <div class="form-text">Debe ser un número entero positivo</div>
                            </div>
                            
                            <div class="alert alert-info" role="alert">
                                <small>
                                    <strong>Nota:</strong> Los campos marcados con * son obligatorios
                                </small>
                            </div>
                            
                            <div class="d-flex gap-2 justify-content-end">
                                <a href="ListarLibros" class="btn btn-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-success">
                                    ✅ Registrar Libro
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información adicional -->
                <div class="card shadow-sm mt-3">
                    <div class="card-body">
                        <h6 class="card-title">ℹ️ Información</h6>
                        <ul class="mb-0">
                            <li>El título del libro debe ser único en el sistema</li>
                            <li>La cantidad de páginas debe ser mayor a 0</li>
                            <li>La fecha de registro se asignará automáticamente</li>
                            <li>Una vez registrado, podrás editarlo desde el catálogo</li>
                        </ul>
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
            
            return true;
        }
    </script>
</body>
</html>

