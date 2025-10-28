<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Estadísticas del Sistema - Biblioteca Comunitaria</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="assets/css/styles.css">
    
    <style>
        .stat-card {
            transition: transform 0.3s ease;
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            font-size: 1.1rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .refresh-btn {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        
        .refresh-btn:hover {
            background: linear-gradient(45deg, #0056b3, #004085);
            transform: scale(1.05);
        }
        
        .last-update {
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.jsp">📚 Biblioteca Comunitaria</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="index.jsp">← Volver al Inicio</a>
            </div>
        </div>
    </nav>

    <!-- Dashboard de Estadísticas -->
    <div class="container mt-5">
        <div class="row">
            <div class="col-12 text-center mb-5">
                <h1 class="display-4">📊 Reportes y Estadísticas del Sistema</h1>
                <p class="lead text-muted">Datos en tiempo real del sistema de biblioteca</p>
            </div>
        </div>
        
        <!-- Estadísticas Principales -->
        <div class="row mb-5">
            <div class="col-md-3 mb-4">
                <div class="card stat-card text-center h-100">
                    <div class="card-body">
                        <div class="stat-number text-success">${totalLectores}</div>
                        <div class="stat-label">Total Lectores</div>
                        <small class="text-muted">Usuarios registrados</small>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-4">
                <div class="card stat-card text-center h-100">
                    <div class="card-body">
                        <div class="stat-number text-info">${materialesDisponibles}</div>
                        <div class="stat-label">Materiales Disponibles</div>
                        <small class="text-muted">Libros y artículos</small>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-4">
                <div class="card stat-card text-center h-100">
                    <div class="card-body">
                        <div class="stat-number text-warning">${prestamosActivos}</div>
                        <div class="stat-label">Préstamos Activos</div>
                        <small class="text-muted">En curso</small>
                    </div>
                </div>
            </div>
            
            <div class="col-md-3 mb-4">
                <div class="card stat-card text-center h-100">
                    <div class="card-body">
                        <div class="stat-number text-danger">${prestamosVencidos}</div>
                        <div class="stat-label">Préstamos Vencidos</div>
                        <small class="text-muted">Requieren atención</small>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Estadísticas Detalladas -->
        <div class="row mb-5">
            <div class="col-md-4 mb-4">
                <div class="card stat-card text-center h-100">
                    <div class="card-body">
                        <div class="stat-number text-primary">${totalMateriales}</div>
                        <div class="stat-label">Total Materiales</div>
                        <small class="text-muted">${totalLibros} libros + ${totalArticulos} artículos</small>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card stat-card text-center h-100">
                    <div class="card-body">
                        <div class="stat-number text-secondary">${prestamosEsteMes}</div>
                        <div class="stat-label">Préstamos Este Mes</div>
                        <small class="text-muted">Actividad reciente</small>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card stat-card text-center h-100">
                    <div class="card-body">
                        <div class="stat-number text-success">${prestamosDevueltos}</div>
                        <div class="stat-label">Préstamos Devueltos</div>
                        <small class="text-muted">Completados</small>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Desglose de Préstamos -->
        <div class="row mb-5">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">📈 Estado de Préstamos</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-3">
                                <div class="p-3">
                                    <h4 class="text-warning">${prestamosActivos}</h4>
                                    <p class="mb-0">En Curso</p>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3">
                                    <h4 class="text-info">${prestamosPendientes}</h4>
                                    <p class="mb-0">Pendientes</p>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3">
                                    <h4 class="text-success">${prestamosDevueltos}</h4>
                                    <p class="mb-0">Devueltos</p>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3">
                                    <h4 class="text-danger">${prestamosVencidos}</h4>
                                    <p class="mb-0">Vencidos</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Información de Actualización -->
        <div class="row">
            <div class="col-md-6">
                <div class="card text-center h-100">
                    <div class="card-body">
                        <h5 class="card-title text-secondary">🕒 Última Actualización</h5>
                        <p class="card-text last-update">
                            <%= new java.util.Date().toString() %>
                        </p>
                        <small class="text-muted">Los datos se actualizan en tiempo real</small>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card text-center h-100">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <h5 class="card-title text-primary">🔄 Actualizar Datos</h5>
                        <a href="Estadisticas" class="btn refresh-btn text-white">
                            Actualizar Estadísticas
                        </a>
                        <small class="text-muted mt-2">Haz clic para refrescar</small>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Botones de Navegación -->
        <div class="text-center mt-5">
            <a href="index.jsp" class="btn btn-outline-primary me-3">
                🏠 Ir al Inicio
            </a>
            <a href="ListarMateriales" class="btn btn-outline-info me-3">
                📚 Ver Catálogo
            </a>
            <a href="login.jsp" class="btn btn-outline-success">
                🔐 Iniciar Sesión
            </a>
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
    
    <script>
        // Auto-refresh cada 30 segundos
        setTimeout(function() {
            location.reload();
        }, 30000);
        
        // Animación de números
        $(document).ready(function() {
            $('.stat-number').each(function() {
                var $this = $(this);
                var countTo = parseInt($this.text());
                
                $({ countNum: 0 }).animate({
                    countNum: countTo
                }, {
                    duration: 2000,
                    easing: 'swing',
                    step: function() {
                        $this.text(Math.floor(this.countNum));
                    },
                    complete: function() {
                        $this.text(this.countNum);
                    }
                });
            });
        });
    </script>
</body>
</html>


