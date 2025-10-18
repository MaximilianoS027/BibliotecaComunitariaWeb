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
                    <li class="nav-item">
                        <button class="btn btn-outline-light theme-toggle" onclick="toggleTheme()" id="themeToggle">
                            <span id="themeIcon">🌙</span>
                        </button>
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
                    <span class="number" id="libros-disponibles">1,247</span>
                    <span class="label">Libros Disponibles</span>
                </div>
                <div class="stat">
                    <span class="number" id="lectores-activos">89</span>
                    <span class="label">Lectores Activos</span>
                </div>
                <div class="stat">
                    <span class="number" id="prestamos-mes">156</span>
                    <span class="label">Préstamos Este Mes</span>
                </div>
            </div>
        </div>

        <!-- Carrusel de Libros Destacados -->
        <div class="featured-books-section mt-5">
            <h2 class="text-center mb-4">📚 Libros Destacados</h2>
            <div class="books-carousel">
                <div class="carousel-container">
                    <div class="book-card">
                        <div class="book-cover">📖</div>
                        <h4>El Quijote</h4>
                        <p>Miguel de Cervantes</p>
                        <span class="book-status available">Disponible</span>
                    </div>
                    <div class="book-card">
                        <div class="book-cover">📚</div>
                        <h4>Cien Años de Soledad</h4>
                        <p>Gabriel García Márquez</p>
                        <span class="book-status available">Disponible</span>
                    </div>
                    <div class="book-card">
                        <div class="book-cover">📕</div>
                        <h4>1984</h4>
                        <p>George Orwell</p>
                        <span class="book-status borrowed">Prestado</span>
                    </div>
                    <div class="book-card">
                        <div class="book-cover">📗</div>
                        <h4>Don Juan Tenorio</h4>
                        <p>José Zorrilla</p>
                        <span class="book-status available">Disponible</span>
                    </div>
                    <div class="book-card">
                        <div class="book-cover">📘</div>
                        <h4>La Odisea</h4>
                        <p>Homero</p>
                        <span class="book-status available">Disponible</span>
                    </div>
                </div>
                <div class="carousel-controls">
                    <button class="carousel-btn prev" onclick="moveCarousel(-1)">❮</button>
                    <button class="carousel-btn next" onclick="moveCarousel(1)">❯</button>
                </div>
            </div>
        </div>

        <!-- Cards Section -->
        <div class="row mt-5">
            <div class="col-md-4">
                <div class="card shadow-sm">
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
            <div class="col-md-4">
                <div class="card shadow-sm">
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
            <div class="col-md-4">
                <div class="card shadow-sm">
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
</body>
</html>


