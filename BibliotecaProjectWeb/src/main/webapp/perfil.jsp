<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Verificar que el usuario esté autenticado
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("usuarioId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String rol = (String) userSession.getAttribute("rol");
    String email = (String) userSession.getAttribute("usuarioEmail");
    String usuarioId = (String) userSession.getAttribute("usuarioId");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Mi Perfil - Biblioteca Comunitaria</title>
    
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
                    <% if ("LECTOR".equals(rol)) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="misPrestamos.jsp">Mis Préstamos</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="catalogo.jsp">Catálogo</a>
                        </li>
                    <% } else if ("BIBLIOTECARIO".equals(rol)) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionLectores.jsp">Lectores</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionMateriales.jsp">Materiales</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="gestionPrestamos.jsp">Préstamos</a>
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
                            <li><a class="dropdown-item active" href="perfil.jsp">Mi Perfil</a></li>
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
        <!-- Mensajes de éxito y error -->
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            if (success != null) {
                if ("password_cambiado".equals(success)) {
        %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>✅ ¡Éxito!</strong> Tu contraseña ha sido cambiada correctamente.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <%
                }
            }
            
            if (error != null) {
                String errorMessage = "";
                String errorClass = "alert-danger";
                
                switch (error) {
                    case "campos_vacios":
                        errorMessage = "❌ Todos los campos son obligatorios.";
                        break;
                    case "password_no_coincide":
                        errorMessage = "❌ Las contraseñas nuevas no coinciden.";
                        break;
                    case "password_corto":
                        errorMessage = "❌ La nueva contraseña debe tener al menos 6 caracteres.";
                        break;
                    case "password_igual":
                        errorMessage = "❌ La nueva contraseña debe ser diferente a la actual.";
                        break;
                    case "password_incorrecto":
                        errorMessage = "❌ La contraseña actual es incorrecta.";
                        break;
                    case "bibliotecario_no_existe":
                        errorMessage = "❌ El bibliotecario no existe en el sistema.";
                        break;
                    case "lector_no_existe":
                        errorMessage = "❌ El lector no existe en el sistema.";
                        break;
                    case "rol_invalido":
                        errorMessage = "❌ Rol de usuario inválido.";
                        break;
                    case "sistema":
                        errorMessage = "❌ Error interno del sistema. Intente nuevamente.";
                        break;
                    case "cambio_no_persistio":
                        errorMessage = "❌ El cambio de contraseña no se guardó correctamente. Contacte al administrador.";
                        break;
                    case "verificacion_fallida":
                        errorMessage = "❌ No se pudo verificar el cambio de contraseña. Intente nuevamente.";
                        break;
                    case "numero_empleado_no_encontrado":
                        errorMessage = "❌ No se pudo encontrar el número de empleado. Contacte al administrador.";
                        break;
                    default:
                        errorMessage = "❌ Error desconocido. Intente nuevamente.";
                }
        %>
        <div class="alert <%= errorClass %> alert-dismissible fade show" role="alert">
            <strong><%= errorMessage %></strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <%
            }
        %>
        
        <div class="row">
            <div class="col-12">
                <h2>👤 Mi Perfil</h2>
                <p class="text-muted">Gestiona tu información personal y configuración de cuenta</p>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Información Personal</h5>
                        <form>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" value="<%= email %>" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="rol" class="form-label">Rol</label>
                                        <input type="text" class="form-control" id="rol" value="<%= rol %>" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="usuarioId" class="form-label">ID de Usuario</label>
                                <input type="text" class="form-control" id="usuarioId" value="<%= usuarioId %>" readonly>
                            </div>
                            <div class="alert alert-info" role="alert">
                                <h6 class="alert-heading">ℹ️ Información</h6>
                                <p class="mb-0">Para modificar tu información personal, contacta con un bibliotecario.</p>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Formulario de Cambio de Contraseña -->
                <div class="card mt-4">
                    <div class="card-body">
                        <h5 class="card-title">🔒 Cambiar Contraseña</h5>
                        <form id="formCambiarPassword" action="CambiarPassword" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="email" value="<%= email %>">
                            
                            <div class="mb-3">
                                <label for="oldPassword" class="form-label">Contraseña Actual *</label>
                                <input type="password" 
                                       class="form-control" 
                                       id="oldPassword" 
                                       name="oldPassword" 
                                       placeholder="Ingrese su contraseña actual"
                                       required>
                                <div class="invalid-feedback">
                                    Por favor, ingrese su contraseña actual.
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="newPassword" class="form-label">Nueva Contraseña *</label>
                                <input type="password" 
                                       class="form-control" 
                                       id="newPassword" 
                                       name="newPassword" 
                                       placeholder="Mínimo 6 caracteres"
                                       minlength="6"
                                       required>
                                <div class="invalid-feedback">
                                    La contraseña debe tener al menos 6 caracteres.
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirmar Nueva Contraseña *</label>
                                <input type="password" 
                                       class="form-control" 
                                       id="confirmPassword" 
                                       name="confirmPassword" 
                                       placeholder="Repita la nueva contraseña"
                                       required>
                                <div class="invalid-feedback">
                                    Las contraseñas deben coincidir.
                                </div>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-warning">Cambiar Contraseña</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Acciones Rápidas</h5>
                        <div class="d-grid gap-2">
                            <a href="home.jsp" class="btn btn-primary">Volver al Inicio</a>
                            <% if ("LECTOR".equals(rol)) { %>
                                <a href="misPrestamos.jsp" class="btn btn-outline-primary">Mis Préstamos</a>
                                <a href="catalogo.jsp" class="btn btn-outline-info">Ver Catálogo</a>
                            <% } else if ("BIBLIOTECARIO".equals(rol)) { %>
                                <a href="gestionBibliotecarios.jsp" class="btn btn-outline-success">Gestionar Bibliotecarios</a>
                                <a href="reportes.jsp" class="btn btn-outline-success">Ver Reportes</a>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <div class="card mt-3">
                    <div class="card-body">
                        <h5 class="card-title">🔐 Seguridad</h5>
                        <ul class="list-unstyled">
                            <li><strong>Último acceso:</strong> Hoy</li>
                            <li><strong>Sesión activa:</strong> Sí</li>
                            <li><strong>Cambio de contraseña:</strong> Disponible</li>
                        </ul>
                        <div class="alert alert-warning" role="alert">
                            <small>Cambia tu contraseña regularmente para mayor seguridad.</small>
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
        // Validación de Bootstrap
        (function() {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function(form) {
                form.addEventListener('submit', function(event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();

        // Validación de contraseñas
        document.getElementById('confirmPassword').addEventListener('input', function() {
            var newPassword = document.getElementById('newPassword').value;
            var confirmPassword = this.value;
            
            if (newPassword !== confirmPassword) {
                this.setCustomValidity('Las contraseñas no coinciden');
            } else {
                this.setCustomValidity('');
            }
        });

        // Validación de contraseña actual vs nueva
        document.getElementById('newPassword').addEventListener('input', function() {
            var oldPassword = document.getElementById('oldPassword').value;
            var newPassword = this.value;
            
            if (oldPassword === newPassword && oldPassword !== '') {
                this.setCustomValidity('La nueva contraseña debe ser diferente a la actual');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
