/**
 * Biblioteca Comunitaria - JavaScript Principal
 * Incluye funciones AJAX con jQuery para notificaciones sin recargar página
 */

$(document).ready(function() {
    console.log("Biblioteca Comunitaria - Sistema cargado");
    
    // Inicializar tooltips de Bootstrap
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Inicializar animaciones de estadísticas
    inicializarEstadisticas();
    
    // Inicializar tema
    inicializarTema();
    
    // Actualizar estadísticas cada 30 segundos
    setInterval(actualizarEstadisticas, 30000);
});

/**
 * Muestra una notificación en la parte superior derecha
 * @param {string} mensaje - Mensaje a mostrar
 * @param {string} tipo - Tipo de alerta: success, danger, warning, info
 * @param {number} duracion - Duración en ms (default: 3000)
 */
function mostrarNotificacion(mensaje, tipo = 'info', duracion = 3000) {
    const tipoClase = `alert-${tipo}`;
    const icono = obtenerIcono(tipo);
    
    const notificacion = $(`
        <div class="alert ${tipoClase} alert-dismissible fade show notification" role="alert">
            ${icono} ${mensaje}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    `);
    
    $('body').append(notificacion);
    
    // Auto-cerrar después de la duración especificada
    setTimeout(function() {
        notificacion.alert('close');
    }, duracion);
}

/**
 * Obtiene el icono según el tipo de notificación
 */
function obtenerIcono(tipo) {
    const iconos = {
        'success': '✅',
        'danger': '❌',
        'warning': '⚠️',
        'info': 'ℹ️'
    };
    return iconos[tipo] || 'ℹ️';
}

/**
 * Muestra un spinner de carga
 */
function mostrarSpinner(contenedorId) {
    $(`#${contenedorId}`).html('<div class="spinner"></div>');
}

/**
 * Oculta el spinner de carga
 */
function ocultarSpinner(contenedorId) {
    $(`#${contenedorId}`).html('');
}

/**
 * Realiza una petición AJAX POST
 * @param {string} url - URL del servlet
 * @param {object} datos - Datos a enviar
 * @param {function} onSuccess - Callback de éxito
 * @param {function} onError - Callback de error
 */
function enviarFormularioAjax(url, datos, onSuccess, onError) {
    $.ajax({
        type: 'POST',
        url: url,
        data: datos,
        success: function(response) {
            if (onSuccess) {
                onSuccess(response);
            }
        },
        error: function(xhr, status, error) {
            console.error('Error AJAX:', error);
            mostrarNotificacion('Error al procesar la solicitud: ' + error, 'danger');
            if (onError) {
                onError(xhr, status, error);
            }
        }
    });
}

/**
 * Realiza una petición AJAX GET
 * @param {string} url - URL del servlet
 * @param {object} params - Parámetros query string
 * @param {function} onSuccess - Callback de éxito
 * @param {function} onError - Callback de error
 */
function obtenerDatosAjax(url, params, onSuccess, onError) {
    $.ajax({
        type: 'GET',
        url: url,
        data: params,
        success: function(response) {
            if (onSuccess) {
                onSuccess(response);
            }
        },
        error: function(xhr, status, error) {
            console.error('Error AJAX:', error);
            mostrarNotificacion('Error al obtener datos: ' + error, 'danger');
            if (onError) {
                onError(xhr, status, error);
            }
        }
    });
}

/**
 * Valida un formulario antes de enviar
 * @param {string} formId - ID del formulario
 * @returns {boolean} - true si es válido, false si no
 */
function validarFormulario(formId) {
    const form = document.getElementById(formId);
    if (!form.checkValidity()) {
        form.classList.add('was-validated');
        mostrarNotificacion('Por favor, complete todos los campos requeridos', 'warning');
        return false;
    }
    return true;
}

/**
 * Confirma una acción con el usuario
 * @param {string} mensaje - Mensaje de confirmación
 * @param {function} onConfirm - Callback si confirma
 */
function confirmarAccion(mensaje, onConfirm) {
    if (confirm(mensaje)) {
        onConfirm();
    }
}

/**
 * Formatea una fecha en formato dd/mm/yyyy
 * @param {string} fecha - Fecha en formato ISO o Date object
 * @returns {string} - Fecha formateada
 */
function formatearFecha(fecha) {
    const d = new Date(fecha);
    const dia = String(d.getDate()).padStart(2, '0');
    const mes = String(d.getMonth() + 1).padStart(2, '0');
    const anio = d.getFullYear();
    return `${dia}/${mes}/${anio}`;
}

/**
 * Limpia un formulario
 * @param {string} formId - ID del formulario
 */
function limpiarFormulario(formId) {
    document.getElementById(formId).reset();
    $(`#${formId}`).removeClass('was-validated');
}

/**
 * Deshabilita un botón durante una operación
 * @param {string} btnId - ID del botón
 * @param {string} textoLoading - Texto a mostrar durante la carga
 */
function deshabilitarBoton(btnId, textoLoading = 'Cargando...') {
    const btn = $(`#${btnId}`);
    btn.data('texto-original', btn.html());
    btn.prop('disabled', true);
    btn.html(`<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> ${textoLoading}`);
}

/**
 * Habilita un botón después de una operación
 * @param {string} btnId - ID del botón
 */
function habilitarBoton(btnId) {
    const btn = $(`#${btnId}`);
    const textoOriginal = btn.data('texto-original');
    btn.prop('disabled', false);
    btn.html(textoOriginal);
}

/**
 * Redirige a otra página después de un delay
 * @param {string} url - URL de destino
 * @param {number} delay - Delay en ms (default: 1500)
 */
function redirigirConDelay(url, delay = 1500) {
    setTimeout(function() {
        window.location.href = url;
    }, delay);
}

// ===================================
// Funciones específicas de la aplicación
// ===================================

/**
 * Maneja el envío de formulario de login
 */
function submitLogin(event) {
    event.preventDefault();
    
    if (!validarFormulario('loginForm')) {
        return false;
    }
    
    deshabilitarBoton('btnLogin', 'Iniciando sesión...');
    
    const email = $('#email').val();
    const password = $('#password').val();
    const rol = $('#rol').val();
    
    enviarFormularioAjax('Login', {
        email: email,
        password: password,
        rol: rol
    }, function(response) {
        habilitarBoton('btnLogin');
        mostrarNotificacion('Inicio de sesión exitoso', 'success');
        redirigirConDelay('home.jsp', 1000);
    }, function(xhr, status, error) {
        habilitarBoton('btnLogin');
        mostrarNotificacion('Credenciales inválidas', 'danger');
    });
    
    return false;
}

/**
 * Cierra la sesión del usuario
 */
function cerrarSesion() {
    confirmarAccion('¿Está seguro que desea cerrar sesión?', function() {
        window.location.href = 'Logout';
    });
}

// ===================================
// Funciones de animación de estadísticas
// ===================================

/**
 * Inicializa las animaciones de las estadísticas
 */
function inicializarEstadisticas() {
    // Animar números al cargar la página
    animarNumero('libros-disponibles', 1247);
    animarNumero('lectores-activos', 89);
    animarNumero('prestamos-mes', 156);
}

/**
 * Anima un número desde 0 hasta su valor final
 * @param {string} elementId - ID del elemento
 * @param {number} valorFinal - Valor final del número
 * @param {number} duracion - Duración de la animación en ms
 */
function animarNumero(elementId, valorFinal, duracion = 2000) {
    const elemento = document.getElementById(elementId);
    if (!elemento) return;
    
    const incremento = valorFinal / (duracion / 16); // 60 FPS
    let valorActual = 0;
    
    const animacion = setInterval(() => {
        valorActual += incremento;
        if (valorActual >= valorFinal) {
            valorActual = valorFinal;
            clearInterval(animacion);
        }
        
        // Formatear número con comas
        elemento.textContent = Math.floor(valorActual).toLocaleString();
    }, 16);
}

/**
 * Actualiza las estadísticas con valores reales (simulados)
 */
function actualizarEstadisticas() {
    // Simular variaciones en las estadísticas
    const variacion = () => Math.floor(Math.random() * 10) - 5; // -5 a +5
    
    const librosActuales = parseInt($('#libros-disponibles').text().replace(/,/g, ''));
    const lectoresActuales = parseInt($('#lectores-activos').text().replace(/,/g, ''));
    const prestamosActuales = parseInt($('#prestamos-mes').text().replace(/,/g, ''));
    
    const nuevosLibros = Math.max(0, librosActuales + variacion());
    const nuevosLectores = Math.max(0, lectoresActuales + variacion());
    const nuevosPrestamos = Math.max(0, prestamosActuales + variacion());
    
    // Animar hacia los nuevos valores
    animarNumero('libros-disponibles', nuevosLibros, 1000);
    animarNumero('lectores-activos', nuevosLectores, 1000);
    animarNumero('prestamos-mes', nuevosPrestamos, 1000);
}

/**
 * Efecto de partículas flotantes mejorado en el fondo
 */
function crearParticulas() {
    const particulas = [];
    const numParticulas = 30;
    const colores = ['#667eea', '#764ba2', '#4facfe', '#00f2fe', '#43e97b', '#38f9d7', '#fa709a', '#fee140'];
    
    for (let i = 0; i < numParticulas; i++) {
        const particula = document.createElement('div');
        particula.className = 'particula';
        const color = colores[Math.floor(Math.random() * colores.length)];
        const size = Math.random() * 6 + 2; // 2-8px
        const delay = Math.random() * 10; // 0-10s delay
        
        particula.style.cssText = `
            position: fixed;
            width: ${size}px;
            height: ${size}px;
            background: ${color};
            border-radius: 50%;
            pointer-events: none;
            z-index: -1;
            left: ${Math.random() * 100}%;
            top: 100vh;
            animation: floatUp ${8 + Math.random() * 12}s linear infinite;
            animation-delay: ${delay}s;
            box-shadow: 0 0 10px ${color};
        `;
        
        document.body.appendChild(particula);
        particulas.push(particula);
    }
    
    // Agregar CSS para la animación de flotar mejorada
    if (!document.getElementById('particulas-css')) {
        const style = document.createElement('style');
        style.id = 'particulas-css';
        style.textContent = `
            @keyframes floatUp {
                0% {
                    transform: translateY(0) rotate(0deg);
                    opacity: 0;
                }
                10% {
                    opacity: 1;
                }
                90% {
                    opacity: 1;
                }
                100% {
                    transform: translateY(-100vh) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    }
}

// Inicializar partículas al cargar
$(document).ready(function() {
    crearParticulas();
    inicializarCarrusel();
});

// ===================================
// Funciones del carrusel de libros
// ===================================

let currentSlide = 0;
const slidesToShow = 3;

/**
 * Inicializa el carrusel de libros
 */
function inicializarCarrusel() {
    const container = document.querySelector('.carousel-container');
    if (!container) return;
    
    // Auto-avanzar cada 5 segundos
    setInterval(() => {
        moveCarousel(1);
    }, 5000);
}

/**
 * Mueve el carrusel en la dirección especificada
 * @param {number} direction - 1 para siguiente, -1 para anterior
 */
function moveCarousel(direction) {
    const container = document.querySelector('.carousel-container');
    const bookCards = document.querySelectorAll('.book-card');
    
    if (!container || !bookCards.length) return;
    
    const totalSlides = bookCards.length;
    const maxSlide = Math.max(0, totalSlides - slidesToShow);
    
    currentSlide += direction;
    
    if (currentSlide < 0) {
        currentSlide = maxSlide;
    } else if (currentSlide > maxSlide) {
        currentSlide = 0;
    }
    
    const translateX = -currentSlide * (200 + 24); // 200px width + 24px gap
    container.style.transform = `translateX(${translateX}px)`;
    
    // Agregar efecto de rebote
    container.style.transition = 'transform 0.5s cubic-bezier(0.25, 0.8, 0.25, 1)';
}

// ===================================
// Funciones del modo oscuro/claro
// ===================================

/**
 * Alterna entre modo oscuro y claro
 */
function toggleTheme() {
    const body = document.body;
    const themeIcon = document.getElementById('themeIcon');
    const currentTheme = body.getAttribute('data-theme');
    
    if (currentTheme === 'dark') {
        body.setAttribute('data-theme', 'light');
        themeIcon.textContent = '🌙';
        localStorage.setItem('theme', 'light');
    } else {
        body.setAttribute('data-theme', 'dark');
        themeIcon.textContent = '☀️';
        localStorage.setItem('theme', 'dark');
    }
    
    // Efecto de transición suave
    body.style.transition = 'all 0.3s ease';
}

/**
 * Inicializa el tema guardado
 */
function inicializarTema() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    const body = document.body;
    const themeIcon = document.getElementById('themeIcon');
    
    body.setAttribute('data-theme', savedTheme);
    themeIcon.textContent = savedTheme === 'dark' ? '☀️' : '🌙';
}


