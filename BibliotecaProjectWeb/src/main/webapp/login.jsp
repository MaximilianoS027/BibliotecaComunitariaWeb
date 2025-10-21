<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Login - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.jsp">📚 Biblioteca Comunitaria</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                    data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Inicio</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Login Form -->
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="form-container">
                    <h2 class="text-center mb-4">Iniciar Sesión</h2>
                    
                    <% 
                    String error = request.getParameter("error");
                    if (error != null) {
                    %>
                        <div class="alert alert-danger" role="alert">
                            ❌ Credenciales inválidas. Por favor, intente nuevamente.
                        </div>
                    <% } %>
                    
                    <% 
                    String role = request.getParameter("role");
                    String rolTexto = "";
                    String rolColor = "info";
                    boolean mostrarRol = false;
                    
                    if ("lector".equals(role)) {
                        rolTexto = "lector";
                        rolColor = "primary";
                        mostrarRol = true;
                    } else if ("bibliotecario".equals(role)) {
                        rolTexto = "bibliotecario";
                        rolColor = "success";
                        mostrarRol = true;
                    }
                    %>
                    
                    <% if (mostrarRol) { %>
                    <div class="alert alert-<%= rolColor %> text-center" role="alert">
                        Ingresando como <strong><%= rolTexto.toUpperCase() %></strong>
                    </div>
                    <% } else { %>
                    <div class="alert alert-<%= rolColor %> text-center" role="alert">
                        <strong>Ingresar como Usuario</strong>
                    </div>
                    <% } %>
                    
                    <form id="loginForm" action="Login" method="post" class="needs-validation" novalidate>
                        <% if (mostrarRol) { %>
                        <input type="hidden" name="rol" value="<%= rolTexto %>">
                        <% } %>
                        
                        <div class="form-group mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" 
                                   class="form-control" 
                                   id="email" 
                                   name="email" 
                                   placeholder="correo@ejemplo.com"
                                   required>
                            <div class="invalid-feedback">
                                Por favor, ingrese un email válido.
                            </div>
                        </div>
                        
                        <div class="form-group mb-3">
                            <label for="password" class="form-label">Contraseña</label>
                            <input type="password" 
                                   class="form-control" 
                                   id="password" 
                                   name="password" 
                                   placeholder="Contraseña"
                                   required>
                            <div class="invalid-feedback">
                                Por favor, ingrese su contraseña.
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" 
                                    id="btnLogin" 
                                    class="btn btn-<%= rolColor %> btn-lg">
                                Iniciar Sesión
                            </button>
                        </div>
                    </form>
                    
                    <hr class="my-4">
                    
                    <div class="text-center">
                        <p class="text-muted">¿No tienes cuenta?</p>
                        <% if ("bibliotecario".equals(role)) { %>
                            <a href="registro.jsp" class="btn btn-outline-success">Registrarse como Bibliotecario</a>
                        <% } else { %>
                            <a href="registro.jsp" class="btn btn-outline-secondary">Registrarse</a>
                        <% } %>
                    </div>
                    
                    <div class="text-center mt-3">
                        <a href="index.jsp" class="text-muted">← Volver al inicio</a>
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
    </script>
</body>
</html>


