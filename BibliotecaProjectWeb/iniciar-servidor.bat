@echo off
echo ====================================
echo Iniciando Servidor Web - Biblioteca
echo ====================================
echo.

cd /d "%~dp0"
echo Directorio actual: %CD%
echo.

echo [1/3] Limpiando proyecto...
call mvn clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fallo al limpiar el proyecto
    pause
    exit /b %ERRORLEVEL%
)
echo.

echo [2/3] Empaquetando aplicacion...
call mvn package
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fallo al empaquetar
    pause
    exit /b %ERRORLEVEL%
)
echo.

echo [3/3] Iniciando servidor Tomcat...
echo El servidor estara disponible en: http://localhost:8080/BibliotecaWeb/
echo Presiona Ctrl+C para detener el servidor
echo.
call mvn org.codehaus.cargo:cargo-maven3-plugin:1.10.15:run

pause

