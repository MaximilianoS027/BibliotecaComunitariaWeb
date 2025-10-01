package servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import publicadores.AutenticacionWSClient;

/**
 * Servlet para manejar el login de usuarios (Lectores y Bibliotecarios)
 * Consume Web Services de autenticación
 */
@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AutenticacionWSClient autenticacionWS;

    public LoginServlet() {
        super();
        autenticacionWS = new AutenticacionWSClient();
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
            String usuarioId = null;
            
            if ("lector".equals(rol)) {
                // Autenticar lector usando Web Service
                usuarioId = autenticacionWS.autenticarLector(email, password);
                
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
                usuarioId = autenticacionWS.autenticarBibliotecario(email, password);
                
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
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=1&role=" + rol);
        }
    }
}


