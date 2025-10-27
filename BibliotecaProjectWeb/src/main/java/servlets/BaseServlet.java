package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet base que proporciona funcionalidad común para todos los servlets.
 * Reduce código duplicado y estandariza el manejo de errores y sesiones.
 */
public abstract class BaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Configura la codificación UTF-8 para request y response
     */
    protected void setupEncoding(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
    }
    
    /**
     * Redirige a la página de error con un mensaje
     */
    protected void forwardToError(HttpServletRequest request, HttpServletResponse response, 
                                  String message) throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
    
    /**
     * Verifica que exista una sesión válida
     * @return true si la sesión es válida, false en caso contrario
     */
    protected boolean hasValidSession(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return false;
        }
        return true;
    }
    
    /**
     * Verifica que exista una sesión válida con un rol específico
     * @param requiredRole El rol requerido (LECTOR o BIBLIOTECARIO)
     * @return true si la sesión es válida y tiene el rol correcto
     */
    protected boolean checkSessionAndRole(HttpServletRequest request, HttpServletResponse response, 
                                         String requiredRole) throws IOException {
        HttpSession session = request.getSession(false);
        
        // Verificar que existe sesión
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return false;
        }
        
        // Verificar rol si se especifica
        if (requiredRole != null && !requiredRole.isEmpty()) {
            String rol = (String) session.getAttribute("rol");
            if (!requiredRole.equals(rol)) {
                response.sendRedirect("home.jsp?error=permisos");
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Obtiene el rol del usuario de la sesión actual
     * @return El rol del usuario o null si no hay sesión
     */
    protected String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("rol");
        }
        return null;
    }
    
    /**
     * Obtiene el ID del usuario de la sesión actual
     * @return El ID del usuario o null si no hay sesión
     */
    protected String getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("usuarioId");
        }
        return null;
    }
    
    /**
     * Obtiene el email del usuario de la sesión actual
     * @return El email del usuario o null si no hay sesión
     */
    protected String getUserEmail(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("email");
        }
        return null;
    }
    
    /**
     * Log de error simplificado (para desarrollo)
     * En producción debería usar un logger profesional
     */
    protected void logError(String message, Exception e) {
        System.err.println("[ERROR] " + message);
        if (e != null) {
            e.printStackTrace();
        }
    }
    
    /**
     * Log de información simplificado (para desarrollo)
     * En producción debería usar un logger profesional
     */
    protected void logInfo(String message) {
        System.out.println("[INFO] " + message);
    }
}

