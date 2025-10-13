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

/**
 * Servlet para manejar el login de usuarios (Lectores y Bibliotecarios)
 * Consume Web Services de autenticación
 */
@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AutenticacionPublicador autenticacionWS;

    public LoginServlet() {
        super();
        autenticacionWS = new AutenticacionPublicadorService().getAutenticacionPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        
        try {
            System.out.println("=== LOGIN ATTEMPT ===");
            System.out.println("Email: " + email);
            System.out.println("Rol: " + rol);
            System.out.println("Password: " + (password != null ? "***" : "null"));
            
            String usuarioId = null;
            
            if ("lector".equals(rol)) {
                // Autenticar lector usando Web Service
                System.out.println("Intentando autenticar lector...");
                usuarioId = autenticacionWS.autenticarLector(email, password);
                System.out.println("Resultado autenticación lector: " + usuarioId);
                
                if (usuarioId != null && !usuarioId.isEmpty()) {
                    // Crear sesión
                    HttpSession session = request.getSession();
                    session.setAttribute("usuarioId", usuarioId);
                    session.setAttribute("usuarioEmail", email);
                    session.setAttribute("rol", "LECTOR");
                    session.setMaxInactiveInterval(30 * 60); // 30 minutos
                    
                    // Redirigir a home
                    response.sendRedirect("home.jsp");
                    return;
                }
                
            } else if ("bibliotecario".equals(rol)) {
                // Autenticar bibliotecario usando Web Service
                System.out.println("Intentando autenticar bibliotecario...");
                usuarioId = autenticacionWS.autenticarBibliotecario(email, password);
                System.out.println("Resultado autenticación bibliotecario: " + usuarioId);
                
                if (usuarioId != null && !usuarioId.isEmpty()) {
                    // Crear sesión
                    HttpSession session = request.getSession();
                    session.setAttribute("usuarioId", usuarioId);
                    session.setAttribute("usuarioEmail", email);
                    session.setAttribute("rol", "BIBLIOTECARIO");
                    session.setMaxInactiveInterval(30 * 60); // 30 minutos
                    
                    // Redirigir a home
                    response.sendRedirect("home.jsp");
                    return;
                }
            }
            
            // Si llegamos aquí, la autenticación falló
            response.sendRedirect("login.jsp?error=1&role=" + rol);
            
        } catch (Exception e) {
            System.out.println("ERROR en LoginServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=1&role=" + rol);
        }
    }
}


