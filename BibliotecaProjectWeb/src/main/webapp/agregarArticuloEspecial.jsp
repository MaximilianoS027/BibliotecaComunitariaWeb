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
    String descripcion = (String) request.getAttribute("descripcion");
    String pesoKg = (String) request.getAttribute("pesoKg");
    String dimensiones = (String) request.getAttribute("dimensiones");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Agregar Artículo Especial - Biblioteca Comunitaria</title>
    
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
                        <h4 class="mb-0">🎁 Registrar Nuevo Artículo Especial</h4>
                    </div>
                    <div class="card-body">
                        <% if (error != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error:</strong> <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                        
                        <form action="AgregarArticuloEspecial" method="post" onsubmit="return validarFormulario()">
                            <div class="mb-3">
                                <label for="descripcion" class="form-label">Descripción *</label>
                                <textarea 
                                    class="form-control" 
                                    id="descripcion" 
                                    name="descripcion" 
                                    rows="3"
                                    placeholder="Ingrese una descripción detallada del artículo especial"
                                    required><%= descripcion != null ? descripcion : "" %></textarea>
                                <div class="form-text">Máximo 500 caracteres</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="pesoKg" class="form-label">Peso (kg) *</label>
                                <input type="number" 
                                       class="form-control" 
                                       id="pesoKg" 
                                       name="pesoKg" 
                                       placeholder="Ej: 2.5"
                                       value="<%= pesoKg != null ? pesoKg : "" %>"
                                       step="0.01"
                                       min="0.01"
                                       required>
                                <div class="form-text">Debe ser un número positivo (se permite decimales)</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="dimensiones" class="form-label">Dimensiones *</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="dimensiones" 
                                       name="dimensiones" 
                                       placeholder="Ej: 30x20x15 cm"
                                       value="<%= dimensiones != null ? dimensiones : "" %>"
                                       required>
                                <div class="form-text">Formato recomendado: Largo x Ancho x Alto (con unidades)</div>
                            </div>
                            
                            <div class="alert alert-info" role="alert">
                                <small>
                                    <strong>Nota:</strong> Los campos marcados con * son obligatorios
                                </small>
                            </div>
                            
                            <div class="d-flex gap-2 justify-content-end">
                                <a href="ListarArticulosEspeciales" class="btn btn-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-success">
                                    ✅ Registrar Artículo Especial
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información adicional -->
                <div class="card shadow-sm mt-3">
                    <div class="card-body">
                        <h6 class="card-title">ℹ️ Información sobre Artículos Especiales</h6>
                        <ul class="mb-0">
                            <li>Los artículos especiales son materiales no convencionales (juegos, mapas, instrumentos, etc.)</li>
                            <li>La descripción debe ser detallada para identificar correctamente el artículo</li>
                            <li>El peso debe estar en kilogramos (kg)</li>
                            <li>Las dimensiones ayudan a gestionar el espacio de almacenamiento</li>
                            <li>La fecha de registro se asignará automáticamente</li>
                            <li>El artículo quedará disponible para préstamo inmediatamente</li>
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
            const descripcion = document.getElementById('descripcion').value.trim();
            const pesoKg = document.getElementById('pesoKg').value;
            const dimensiones = document.getElementById('dimensiones').value.trim();
            
            if (descripcion === '') {
                alert('La descripción es obligatoria');
                return false;
            }
            
            if (descripcion.length > 500) {
                alert('La descripción no puede exceder los 500 caracteres');
                return false;
            }
            
            if (pesoKg <= 0) {
                alert('El peso debe ser mayor a 0 kg');
                return false;
            }
            
            if (dimensiones === '') {
                alert('Las dimensiones son obligatorias');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>

