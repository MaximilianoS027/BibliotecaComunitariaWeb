<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Registro de Bibliotecario - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
    
    <style>
        /* Placeholders más transparentes y elegantes */
        .form-control::placeholder {
            color: #adb5bd !important;
            opacity: 0.7 !important;
            font-style: italic;
            font-size: 0.9em;
        }
        
        .form-control:focus::placeholder {
            opacity: 0.5 !important;
            transition: opacity 0.3s ease;
        }
        
        /* Mejorar la apariencia de los campos vacíos */
        .form-control:not(:focus):placeholder-shown {
            background-color: #f8f9fa;
            border-color: #e9ecef;
        }
        
        .form-control:focus {
            background-color: #fff;
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
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
                        <a class="nav-link" href="ListarLibros">Materiales</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="RegistroLector">Registrar Lector</a>
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
            <div class="col-md-8">
                <div class="form-container">
                    <h2 class="text-center mb-4">📝 Registro de Bibliotecario</h2>
                    <p class="text-center text-muted">Completa el formulario para registrarte como bibliotecario</p>
                    
                    <!-- Alertas -->
                    <% if (error != null) { %>
                        <div class="alert alert-danger" role="alert">
                            <% if ("campos_vacios".equals(error)) { %>
                                ❌ Por favor, complete todos los campos requeridos.
                            <% } else if ("password_no_coincide".equals(error)) { %>
                                ❌ Las contraseñas no coinciden.
                            <% } else if ("password_corto".equals(error)) { %>
                                ❌ La contraseña debe tener al menos 6 caracteres.
                            <% } else if ("email_invalido".equals(error)) { %>
                                ❌ El formato del email no es válido.
                            <% } else if ("bibliotecario_existe".equals(error)) { %>
                                ❌ Ya existe un bibliotecario con ese email.
                            <% } else if ("datos_invalidos".equals(error)) { %>
                                ❌ Los datos proporcionados no son válidos.
                            <% } else if ("backend_no_disponible".equals(error)) { %>
                                ❌ El servidor backend no está disponible. Contacte al administrador.
                            <% } else if ("timeout".equals(error)) { %>
                                ❌ Tiempo de espera agotado. Intente nuevamente.
                            <% } else if ("backend_error".equals(error)) { %>
                                ❌ Error interno del servidor backend. Contacte al administrador del sistema.
                            <% } else { %>
                                ❌ Error al registrar bibliotecario. Intente nuevamente.
                                <% 
                                String detalle = request.getParameter("detalle");
                                if (detalle != null) { %>
                                    <br><small>Detalle: <%= detalle %></small>
                                <% } %>
                            <% } %>
                        </div>
                    <% } %>

                    <% if (success != null) { %>
                        <div class="alert alert-success" role="alert">
                            ✅ Registro exitoso. Ahora puedes iniciar sesión.
                        </div>
                    <% } %>
                    
                    <form id="formRegistro" action="RegistroBibliotecario" method="post" class="needs-validation" novalidate>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre Completo *</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="nombre" 
                                           name="nombre" 
                                           placeholder="ej: Juan Pérez"
                                           required>
                                    <div class="invalid-feedback">
                                        Por favor, ingrese su nombre completo.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Correo Electrónico *</label>
                                    <input type="email" 
                                           class="form-control" 
                                           id="email" 
                                           name="email" 
                                           placeholder="ej: bibliotecario@biblioteca.com"
                                           required>
                                    <div class="invalid-feedback">
                                        Por favor, ingrese un email válido.
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="password" class="form-label">Contraseña *</label>
                                    <input type="password" 
                                           class="form-control" 
                                           id="password" 
                                           name="password" 
                                           placeholder="•••••• (mínimo 6 caracteres)"
                                           minlength="6"
                                           required>
                                    <div class="invalid-feedback">
                                        La contraseña debe tener al menos 6 caracteres.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Confirmar Contraseña *</label>
                                    <input type="password" 
                                           class="form-control" 
                                           id="confirmPassword" 
                                           name="confirmPassword" 
                                           placeholder="•••••• (repetir contraseña)"
                                           required>
                                    <div class="invalid-feedback">
                                        Las contraseñas deben coincidir.
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="alert alert-info" role="alert">
                            <h6 class="alert-heading">ℹ️ Información Importante</h6>
                            <ul class="mb-0">
                                <li>El email será tu usuario para iniciar sesión</li>
                                <li>La contraseña debe tener al menos 6 caracteres</li>
                                <li>Una vez registrado, podrás acceder al sistema de gestión</li>
                            </ul>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="login.jsp" class="btn btn-secondary me-md-2">Cancelar</a>
                            <button type="submit" class="btn btn-success">Registrarse</button>
                        </div>
                    </form>
                    
                    <hr class="my-4">
                    
                    <div class="text-center">
                        <p class="text-muted">¿Ya tienes una cuenta?</p>
                        <a href="login.jsp" class="btn btn-outline-primary">Iniciar Sesión</a>
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
            var password = document.getElementById('password').value;
            var confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Las contraseñas no coinciden');
            } else {
                this.setCustomValidity('');
            }
        });

        // Validación de email
        document.getElementById('email').addEventListener('input', function() {
            var email = this.value;
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if (email && !emailRegex.test(email)) {
                this.setCustomValidity('El formato del email no es válido');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>
