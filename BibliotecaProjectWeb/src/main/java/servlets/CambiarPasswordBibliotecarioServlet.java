package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.autenticacion.AutenticacionPublicadorService;
import publicadores.autenticacion.AutenticacionPublicador;
import publicadores.autenticacion.BibliotecarioNoExisteException_Exception;
import publicadores.autenticacion.LectorNoExisteException_Exception;
import publicadores.autenticacion.DatosInvalidosException_Exception;
import publicadores.bibliotecario.BibliotecarioPublicadorService;
import publicadores.bibliotecario.BibliotecarioPublicador;

/**
 * Servlet para cambiar contraseña de usuarios (bibliotecarios y lectores)
 * Consume Web Service de autenticación
 */
@WebServlet("/CambiarPassword")
public class CambiarPasswordBibliotecarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AutenticacionPublicador autenticacionWS;
    private BibliotecarioPublicador bibliotecarioWS;

    public CambiarPasswordBibliotecarioServlet() {
        super();
        autenticacionWS = new AutenticacionPublicadorService().getAutenticacionPublicadorPort();
        bibliotecarioWS = new BibliotecarioPublicadorService().getBibliotecarioPublicadorPort();
    }
    
    /**
     * Obtiene el número de empleado del bibliotecario por su email
     */
    private String obtenerNumeroEmpleado(String email) {
        try {
            publicadores.bibliotecario.StringArray bibliotecariosArray = bibliotecarioWS.listarBibliotecarios();
            java.util.List<String> bibliotecarios = bibliotecariosArray.getItem();
            
            for (String bibliotecario : bibliotecarios) {
                // Formato esperado: "B19 - Nicolas (bibliotecario@bibiliotec.tre)"
                if (bibliotecario.contains("(" + email + ")")) {
                    // Extraer el número de empleado (parte antes del primer espacio)
                    String[] partes = bibliotecario.split(" - ");
                    if (partes.length > 0) {
                        return partes[0]; // Retorna "B19" o el número de empleado
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error al obtener número de empleado: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar que el usuario esté autenticado
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Redirigir al perfil para cambio de contraseña
        response.sendRedirect("perfil.jsp?action=cambiar_password");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String email = request.getParameter("email");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String rol = (String) session.getAttribute("rol");
        String usuarioId = (String) session.getAttribute("usuarioId"); // ID del usuario
        
        // Obtener el número de empleado correcto para bibliotecarios
        String numeroEmpleado = null;
        if ("BIBLIOTECARIO".equals(rol)) {
            numeroEmpleado = obtenerNumeroEmpleado(email);
            if (numeroEmpleado == null) {
                response.sendRedirect("perfil.jsp?error=numero_empleado_no_encontrado");
                return;
            }
        }
        
        try {
            
            // Validaciones básicas
            if (oldPassword == null || oldPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty()) {
                response.sendRedirect("perfil.jsp?error=campos_vacios");
                return;
            }
            
            // Para bibliotecarios, verificar que tenemos el número de empleado
            if ("BIBLIOTECARIO".equals(rol) && (numeroEmpleado == null || numeroEmpleado.trim().isEmpty())) {
                response.sendRedirect("perfil.jsp?error=numero_empleado_no_encontrado");
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("perfil.jsp?error=password_no_coincide");
                return;
            }
            
            if (newPassword.length() < 6) {
                response.sendRedirect("perfil.jsp?error=password_corto");
                return;
            }
            
            if (oldPassword.equals(newPassword)) {
                response.sendRedirect("perfil.jsp?error=password_igual");
                return;
            }
            
            // Cambiar contraseña usando Web Service según el rol
            boolean cambioExitoso = false;
            
            if ("BIBLIOTECARIO".equals(rol)) {
                try {
                    System.out.println("🔧 CAMBIO DE CONTRASEÑA BIBLIOTECARIO:");
                    System.out.println("📧 Email: " + email);
                    System.out.println("👤 Número de empleado: " + numeroEmpleado);
                    System.out.println("🔐 Contraseña actual: " + oldPassword);
                    System.out.println("🔑 Nueva contraseña: " + newPassword);
                    
                    autenticacionWS.cambiarPasswordBibliotecario(numeroEmpleado, oldPassword, newPassword);
                    cambioExitoso = true;
                    System.out.println("✅ Llamada al Web Service exitosa");
                } catch (Exception e) {
                    System.err.println("❌ Error al cambiar contraseña de bibliotecario: " + e.getMessage());
                    e.printStackTrace();
                    throw e; // Re-lanzar para manejo específico
                }
            } else if ("LECTOR".equals(rol)) {
                try {
                    autenticacionWS.cambiarPasswordLector(usuarioId, oldPassword, newPassword);
                    cambioExitoso = true;
                } catch (Exception e) {
                    System.err.println("Error al cambiar contraseña de lector: " + e.getMessage());
                    e.printStackTrace();
                    throw e; // Re-lanzar para manejo específico
                }
            } else {
                response.sendRedirect("perfil.jsp?error=rol_invalido");
                return;
            }
            
            // Verificar que el cambio fue exitoso probando login con nueva contraseña
            if (cambioExitoso) {
                try {
                    String emailUsuario = (String) session.getAttribute("usuarioEmail");
                    
                    // Esperar un momento para que el backend procese el cambio
                    Thread.sleep(1000);
                    
                    String resultadoLogin = autenticacionWS.autenticarBibliotecario(emailUsuario, newPassword);
                    
                    if (resultadoLogin != null && !resultadoLogin.isEmpty()) {
                        // El cambio fue exitoso y la nueva contraseña funciona
                        System.out.println("✅ VERIFICACIÓN EXITOSA: Nueva contraseña funciona");
                        response.sendRedirect("perfil.jsp?success=password_cambiado");
                    } else {
                        // El cambio no persistió realmente
                        System.err.println("❌ PROBLEMA DETECTADO: El cambio no persistió en el backend");
                        response.sendRedirect("perfil.jsp?error=cambio_no_persistio");
                    }
                } catch (Exception e) {
                    System.err.println("Error al verificar el cambio de contraseña: " + e.getMessage());
                    e.printStackTrace();
                    response.sendRedirect("perfil.jsp?error=verificacion_fallida");
                }
            }
            
        } catch (BibliotecarioNoExisteException_Exception e) {
            response.sendRedirect("perfil.jsp?error=bibliotecario_no_existe");
            
        } catch (LectorNoExisteException_Exception e) {
            response.sendRedirect("perfil.jsp?error=lector_no_existe");
            
        } catch (DatosInvalidosException_Exception e) {
            response.sendRedirect("perfil.jsp?error=password_incorrecto");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("perfil.jsp?error=sistema");
        }
    }
}

