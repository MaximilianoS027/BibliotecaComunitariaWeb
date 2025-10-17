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
import publicadores.autenticacion.DatosInvalidosException_Exception;

/**
 * Servlet para cambiar contraseña de bibliotecarios
 * Consume Web Service de autenticación
 */
@WebServlet("/CambiarPasswordBibliotecario")
public class CambiarPasswordBibliotecarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AutenticacionPublicador autenticacionWS;

    public CambiarPasswordBibliotecarioServlet() {
        super();
        autenticacionWS = new AutenticacionPublicadorService().getAutenticacionPublicadorPort();
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
        
        try {
            
            // Validaciones básicas
            if (email == null || email.trim().isEmpty() ||
                oldPassword == null || oldPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty()) {
                response.sendRedirect("perfil.jsp?error=campos_vacios&action=cambiar_password");
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("perfil.jsp?error=password_no_coincide&action=cambiar_password");
                return;
            }
            
            if (newPassword.length() < 6) {
                response.sendRedirect("perfil.jsp?error=password_corto&action=cambiar_password");
                return;
            }
            
            // Cambiar contraseña usando Web Service
            autenticacionWS.cambiarPasswordBibliotecario(email, oldPassword, newPassword);
            
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("perfil.jsp?success=password_cambiado");
            
        } catch (BibliotecarioNoExisteException_Exception e) {
            response.sendRedirect("perfil.jsp?error=bibliotecario_no_existe&action=cambiar_password");
            
        } catch (DatosInvalidosException_Exception e) {
            response.sendRedirect("perfil.jsp?error=password_incorrecto&action=cambiar_password");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("perfil.jsp?error=sistema&action=cambiar_password");
        }
    }
}

