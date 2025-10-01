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


