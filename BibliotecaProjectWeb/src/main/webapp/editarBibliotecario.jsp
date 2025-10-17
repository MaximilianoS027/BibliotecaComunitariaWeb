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
    <title>Editar Bibliotecario - Biblioteca Comunitaria</title>
    
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
                        <a class="nav-link" href="agregarBibliotecario.jsp">Agregar Bibliotecario</a>
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
                <h2>✏️ Editar Bibliotecario</h2>
                <p class="text-muted">Modifica los datos del bibliotecario</p>
            </div>
        </div>

        <!-- Alertas -->
        <% if (error != null) { %>
            <div class="alert alert-danger" role="alert">
                <% if ("campos_vacios".equals(error)) { %>
                    ❌ Por favor, complete todos los campos requeridos.
                <% } else if ("bibliotecario_no_existe".equals(error)) { %>
                    ❌ El bibliotecario no existe en el sistema.
                <% } else if ("sistema".equals(error)) { %>
                    ❌ Error del sistema. Intente nuevamente.
                <% } else { %>
                    ❌ Error al modificar bibliotecario. Intente nuevamente.
                <% } %>
            </div>
        <% } %>

        <% if (success != null) { %>
            <div class="alert alert-success" role="alert">
                ✅ Bibliotecario modificado exitosamente.
            </div>
        <% } %>

        <!-- Formulario -->
        <div class="row mt-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Datos del Bibliotecario</h5>
                        <form id="formEditarBibliotecario" action="ModificarBibliotecario" method="post" class="needs-validation" novalidate>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" 
                                               class="form-control" 
                                               id="email" 
                                               name="email" 
                                               value="${bibliotecario.email}"
                                               readonly>
                                        <div class="form-text">El email no se puede modificar</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="numeroEmpleado" class="form-label">Número de Empleado</label>
                                        <input type="text" 
                                               class="form-control" 
                                               id="numeroEmpleado" 
                                               name="numeroEmpleado" 
                                               value="${bibliotecario.numeroEmpleado}"
                                               placeholder="Ej: EMP001">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre Completo *</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="nombre" 
                                       name="nombre" 
                                       value="${bibliotecario.nombre}"
                                       placeholder="Juan Pérez"
                                       required>
                                <div class="invalid-feedback">
                                    Por favor, ingrese el nombre completo.
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="gestionBibliotecarios.jsp" class="btn btn-secondary me-md-2">Cancelar</a>
                                <button type="submit" class="btn btn-success">Guardar Cambios</button>
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
                            <li><strong>Email:</strong> No se puede modificar</li>
                            <li><strong>Nombre:</strong> Nombre completo del bibliotecario</li>
                            <li><strong>Número Empleado:</strong> Identificador interno (opcional)</li>
                        </ul>
                        <div class="alert alert-warning" role="alert">
                            <small>Para cambiar la contraseña, el bibliotecario debe hacerlo desde su perfil.</small>
                        </div>
                    </div>
                </div>
                
                <div class="card mt-3">
                    <div class="card-body">
                        <h5 class="card-title">🔧 Acciones</h5>
                        <div class="d-grid gap-2">
                            <a href="gestionBibliotecarios.jsp" class="btn btn-outline-primary">
                                ← Volver a la Lista
                            </a>
                            <button type="button" class="btn btn-outline-info" onclick="verDetalles()">
                                👁️ Ver Detalles
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para ver detalles -->
    <div class="modal fade" id="modalDetalles" tabindex="-1" aria-labelledby="modalDetallesLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalDetallesLabel">Detalles del Bibliotecario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-12">
                            <p><strong>Email:</strong> ${bibliotecario.email}</p>
                            <p><strong>Nombre:</strong> ${bibliotecario.nombre}</p>
                            <p><strong>Número de Empleado:</strong> ${bibliotecario.numeroEmpleado != null ? bibliotecario.numeroEmpleado : 'No asignado'}</p>
                            <p><strong>Estado:</strong> <span class="badge bg-success">Activo</span></p>
                        </div>
                    </div>
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

        function verDetalles() {
            $('#modalDetalles').modal('show');
        }
    </script>
</body>
</html>

