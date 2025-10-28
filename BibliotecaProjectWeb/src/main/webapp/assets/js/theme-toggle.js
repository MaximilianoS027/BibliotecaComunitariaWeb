/**
 * Script para Toggle de Tema Claro/Oscuro
 * Biblioteca Comunitaria
 */

// Cargar tema guardado al cargar la página
document.addEventListener('DOMContentLoaded', function() {
    // Aplicar tema guardado
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
    
    // Verificar si existe el botón de toggle (puede no existir en páginas de login)
    const themeToggle = document.getElementById('themeToggle');
    if (themeToggle) {
        // Actualizar texto e icono del botón
        updateThemeButton();
        
        // Agregar event listener
        themeToggle.addEventListener('click', function(e) {
            e.preventDefault();
            toggleTheme();
        });
    }
});

/**
 * Alterna entre modo claro y oscuro
 */
function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateThemeButton();
}

/**
 * Actualiza el texto e icono del botón según el tema actual
 */
function updateThemeButton() {
    const theme = document.documentElement.getAttribute('data-theme');
    const themeIcon = document.getElementById('themeIcon');
    const themeText = document.getElementById('themeText');
    
    if (themeIcon && themeText) {
        if (theme === 'dark') {
            themeIcon.textContent = '☀️';
            themeText.textContent = 'Modo Claro';
        } else {
            themeIcon.textContent = '🌙';
            themeText.textContent = 'Modo Oscuro';
        }
    }
}




