<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Biblioteca Comunitaria</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
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
                    data-bs-target="#navbarNav" aria-controls="navbarNav" 
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Iniciar Sesión</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12 text-center">
                <h1 class="display-4">Bienvenido a la Biblioteca Comunitaria</h1>
                <p class="lead">Sistema de gestión de préstamos de materiales</p>
                <hr class="my-4">
            </div>
        </div>

        <!-- Estadísticas en Tiempo Real -->
        <div class="stats-banner">
            <div class="stats-container">
                <div class="stat">
                    <span class="number" id="libros-disponibles">Cargando...</span>
                    <span class="label">Materiales Disponibles</span>
                </div>
                <div class="stat">
                    <span class="number" id="lectores-activos">Cargando...</span>
                    <span class="label">Total Lectores</span>
                </div>
                <div class="stat">
                    <span class="number" id="prestamos-mes">Cargando...</span>
                    <span class="label">Préstamos Este Mes</span>
                </div>
            </div>
            <div class="text-center mt-3">
                <small class="text-muted">
                    <span id="last-update">Actualizando datos...</span> | 
                    <a href="Estadisticas" class="text-decoration-none">Ver estadísticas completas</a>
                </small>
            </div>
        </div>

        <!-- Sección de Bienvenida -->
        <div class="welcome-section mt-5">
            <div class="card shadow-lg border-0" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="card-body text-white p-5">
                    <h2 class="text-center mb-4" style="font-weight: 700; font-size: 2.5rem;">
                        📚 Bienvenido a la Biblioteca Comunitaria
                    </h2>
                    <div class="row">
                        <div class="col-md-8 mx-auto">
                            <p class="text-center mb-4" style="font-size: 1.2rem; line-height: 1.8;">
                                Un espacio donde el conocimiento se encuentra con la comunidad. Nuestra biblioteca 
                                está dedicada a fomentar el aprendizaje, la cultura y el crecimiento personal a través 
                                del acceso libre a una amplia colección de materiales educativos y literarios.
                            </p>
                            <div class="d-flex justify-content-center align-items-start gap-4 flex-wrap mt-5">
                                <div class="text-center" style="flex: 1; min-width: 250px; max-width: 300px;">
                                    <div class="feature-icon mb-3" style="font-size: 3rem;">📖</div>
                                    <h5 style="font-weight: 600;">Amplio Catálogo</h5>
                                    <p style="font-size: 0.95rem; opacity: 0.9;">
                                        Libros y artículos especiales para todas las edades e intereses
                                    </p>
                                </div>
                                <div class="text-center" style="flex: 1; min-width: 250px; max-width: 300px;">
                                    <div class="feature-icon mb-3" style="font-size: 3rem;">🤝</div>
                                    <h5 style="font-weight: 600;">Servicio Personalizado</h5>
                                    <p style="font-size: 0.95rem; opacity: 0.9;">
                                        Gestión eficiente de préstamos y atención dedicada
                                    </p>
                                </div>
                                <div class="text-center" style="flex: 1; min-width: 250px; max-width: 300px;">
                                    <div class="feature-icon mb-3" style="font-size: 3rem;">🌟</div>
                                    <h5 style="font-weight: 600;">Acceso Digital</h5>
                                    <p style="font-size: 0.95rem; opacity: 0.9;">
                                        Consulta tu historial y solicita materiales en línea
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cards Section -->
        <div class="d-flex justify-content-center align-items-stretch gap-4 flex-wrap mt-5">
            <div style="flex: 1; min-width: 280px; max-width: 350px;">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center">
                        <div class="icon-container mb-3">
                            <div class="icon-lector">👤</div>
                        </div>
                        <h5 class="card-title">Para Lectores</h5>
                        <p class="card-text">Consulta tus préstamos, solicita materiales y gestiona tu perfil.</p>
                        <a href="login.jsp?role=lector" class="btn btn-primary">Acceder</a>
                    </div>
                </div>
            </div>
            <div style="flex: 1; min-width: 280px; max-width: 350px;">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center">
                        <div class="icon-container mb-3">
                            <div class="icon-bibliotecario">👨‍💼</div>
                        </div>
                        <h5 class="card-title">Para Bibliotecarios</h5>
                        <p class="card-text">Registra materiales, gestiona préstamos y controla el inventario.</p>
                        <a href="login.jsp?role=bibliotecario" class="btn btn-success">Acceder</a>
                    </div>
                </div>
            </div>
            <div style="flex: 1; min-width: 280px; max-width: 350px;">
                <div class="card shadow-sm h-100">
                    <div class="card-body text-center">
                        <div class="icon-container mb-3">
                            <div class="icon-catalogo">📖</div>
                        </div>
                        <h5 class="card-title">Catálogo</h5>
                        <p class="card-text">Explora nuestra colección de libros y artículos especiales.</p>
                        <a href="ListarMateriales" class="btn btn-info text-white">Ver Catálogo</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5 py-4 bg-light text-center">
        <div class="container">
            <p class="text-muted mb-0">© 2025 Biblioteca Comunitaria - Sistema de Gestión de Préstamos</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Custom JS -->
    <script src="assets/js/app.js"></script>
    
    <!-- Estadísticas en Tiempo Real -->
    <script>
        // Función para cargar estadísticas reales
        function cargarEstadisticas() {
            console.log('Cargando estadísticas del sistema...');
            
            // Mostrar indicador de carga
            document.getElementById('libros-disponibles').textContent = 'Cargando...';
            document.getElementById('lectores-activos').textContent = 'Cargando...';
            document.getElementById('prestamos-mes').textContent = 'Cargando...';
            document.getElementById('last-update').textContent = 'Actualizando datos...';
            
            // Crear un iframe oculto para cargar las estadísticas
            const iframe = document.createElement('iframe');
            iframe.style.display = 'none';
            iframe.src = 'Estadisticas';
            document.body.appendChild(iframe);
            
            // Cuando el iframe carga, extraer los datos
            iframe.onload = function() {
                try {
                    const iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
                    
                    // Buscar los elementos con los datos
                    const materialesElement = iframeDoc.querySelector('.stat-number.text-info');
                    const lectoresElement = iframeDoc.querySelector('.stat-number.text-success');
                    const prestamosElement = iframeDoc.querySelector('.stat-number.text-secondary');
                    
                    // Actualizar los elementos en la página principal
                    if (materialesElement) {
                        document.getElementById('libros-disponibles').textContent = materialesElement.textContent;
                    }
                    
                    if (lectoresElement) {
                        document.getElementById('lectores-activos').textContent = lectoresElement.textContent;
                    }
                    
                    if (prestamosElement) {
                        document.getElementById('prestamos-mes').textContent = prestamosElement.textContent;
                    }
                    
                    // Actualizar timestamp
                    const now = new Date();
                    document.getElementById('last-update').textContent = 
                        'Última actualización: ' + now.toLocaleTimeString();
                    
                    console.log('Estadísticas cargadas exitosamente');
                    
                } catch (error) {
                    console.error('Error al cargar estadísticas:', error);
                    // En caso de error, usar valores por defecto
                    document.getElementById('libros-disponibles').textContent = 'N/A';
                    document.getElementById('lectores-activos').textContent = 'N/A';
                    document.getElementById('prestamos-mes').textContent = 'N/A';
                    document.getElementById('last-update').textContent = 'Error al cargar datos';
                } finally {
                    // Limpiar el iframe
                    document.body.removeChild(iframe);
                }
            };
            
            // Timeout para evitar que se quede cargando indefinidamente
            setTimeout(function() {
                if (document.getElementById('libros-disponibles').textContent === 'Cargando...') {
                    document.getElementById('libros-disponibles').textContent = 'N/A';
                    document.getElementById('lectores-activos').textContent = 'N/A';
                    document.getElementById('prestamos-mes').textContent = 'N/A';
                    document.getElementById('last-update').textContent = 'Error de conexión';
                    console.error('Timeout al cargar estadísticas');
                }
            }, 10000); // 10 segundos de timeout
        }
        
        // Cargar estadísticas una sola vez cuando la página esté lista
        document.addEventListener('DOMContentLoaded', function() {
            cargarEstadisticas();
        });
    </script>


