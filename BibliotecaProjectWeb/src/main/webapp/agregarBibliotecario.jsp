<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Verificar que el usuario esté autenticado como bibliotecario
    HttpSession userSession = request.getSession(false);
    if (userSession == null || !"BIBLIOTECARIO".equals(userSession.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Agregar Bibliotecario - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="gestionBibliotecarios.jsp">Bibliotecarios</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="agregarBibliotecario.jsp">Agregar Bibliotecario</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reportes.jsp">Reportes</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" 
                           role="button" data-bs-toggle="dropdown">
                            👤 <%= userSession.getAttribute("usuarioEmail") %>
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
                <h2>➕ Agregar Nuevo Bibliotecario</h2>
                <p class="text-muted">Registra un nuevo bibliotecario en el sistema</p>
            </div>
        </div>

        <!-- Alertas -->
        <% if (error != null) { %>
            <div class="alert alert-danger" role="alert">
                <% if ("campos_vacios".equals(error)) { %>
                    ❌ Por favor, complete todos los campos requeridos.
                <% } else if ("password_no_coincide".equals(error)) { %>
                    ❌ Las contraseñas no coinciden.
                <% } else if ("bibliotecario_existe".equals(error)) { %>
                    ❌ Ya existe un bibliotecario con ese email.
                <% } else if ("datos_invalidos".equals(error)) { %>
                    ❌ Los datos proporcionados no son válidos.
                <% } else { %>
                    ❌ Error al agregar bibliotecario. Intente nuevamente.
                <% } %>
            </div>
        <% } %>

        <% if (success != null) { %>
            <div class="alert alert-success" role="alert">
                ✅ Bibliotecario agregado exitosamente.
            </div>
        <% } %>

        <!-- Formulario -->
        <div class="row mt-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Datos del Bibliotecario</h5>
                        <form id="formAgregarBibliotecario" action="AgregarBibliotecario" method="post" class="needs-validation" novalidate>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email *</label>
                                        <input type="email" 
                                               class="form-control" 
                                               id="email" 
                                               name="email" 
                                               placeholder="bibliotecario@biblioteca.com"
                                               required>
                                        <div class="invalid-feedback">
                                            Por favor, ingrese un email válido.
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="nombre" class="form-label">Nombre Completo *</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="nombre" 
                                               name="nombre" 
                                               placeholder="Juan Pérez"
                                               required>
                                        <div class="invalid-feedback">
                                            Por favor, ingrese el nombre completo.
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
                                               placeholder="Mínimo 6 caracteres"
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
                                               placeholder="Repita la contraseña"
                                               required>
                                        <div class="invalid-feedback">
                                            Las contraseñas deben coincidir.
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="gestionBibliotecarios.jsp" class="btn btn-secondary me-md-2">Cancelar</a>
                                <button type="submit" class="btn btn-success">Agregar Bibliotecario</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">ℹ️ Información</h5>
                        <ul class="list-unstyled">
                            <li><strong>Email:</strong> Debe ser único en el sistema</li>
                            <li><strong>Contraseña:</strong> Mínimo 6 caracteres</li>
                            <li><strong>Nombre:</strong> Nombre completo del bibliotecario</li>
                        </ul>
                        <div class="alert alert-info" role="alert">
                            <small>El bibliotecario podrá cambiar su contraseña desde su perfil.</small>
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
            var password = document.getElementById('password').value;
            var confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Las contraseñas no coinciden');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>

