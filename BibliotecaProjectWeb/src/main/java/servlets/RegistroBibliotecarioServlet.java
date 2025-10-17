package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import publicadores.bibliotecario.BibliotecarioPublicadorService;
import publicadores.bibliotecario.BibliotecarioPublicador;
import publicadores.bibliotecario.BibliotecarioRepetidoException_Exception;
import publicadores.bibliotecario.DatosInvalidosException_Exception;

/**
 * Servlet para registro de nuevos bibliotecarios desde la página pública
 * Consume Web Service de bibliotecarios
 */
@WebServlet("/RegistroBibliotecario")
public class RegistroBibliotecarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BibliotecarioPublicador bibliotecarioWS;

    public RegistroBibliotecarioServlet() {
        super();
        bibliotecarioWS = new BibliotecarioPublicadorService().getBibliotecarioPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirigir al formulario de registro
        response.sendRedirect("registro.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        try {
            
            // Validaciones básicas
            if (nombre == null || nombre.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                response.sendRedirect("registro.jsp?error=campos_vacios");
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                response.sendRedirect("registro.jsp?error=password_no_coincide");
                return;
            }
            
            if (password.length() < 6) {
                response.sendRedirect("registro.jsp?error=password_corto");
                return;
            }
            
            // Validar formato de email básico
            if (!email.contains("@") || !email.contains(".")) {
                response.sendRedirect("registro.jsp?error=email_invalido");
                return;
            }
            
            // Registrar bibliotecario usando Web Service
            // Orden correcto: arg0=nombre, arg1=email, arg2=password
            bibliotecarioWS.registrarBibliotecarioConPassword(nombre, email, password);
            
            // Redirigir con mensaje de éxito al login de bibliotecario
            response.sendRedirect("login.jsp?success=registro_exitoso&email=" + email + "&role=bibliotecario");
            
        } catch (BibliotecarioRepetidoException_Exception e) {
            response.sendRedirect("registro.jsp?error=bibliotecario_existe");
            
        } catch (DatosInvalidosException_Exception e) {
            response.sendRedirect("registro.jsp?error=datos_invalidos");
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // Determinar el tipo de error específico
            if (e.getMessage() != null) {
                if (e.getMessage().contains("Connection refused")) {
                    response.sendRedirect("registro.jsp?error=backend_no_disponible");
                } else if (e.getMessage().contains("timeout")) {
                    response.sendRedirect("registro.jsp?error=timeout");
                } else if (e.getMessage().contains("HTTP 500")) {
                    // Error HTTP 500 - probablemente bibliotecario ya existe
                    response.sendRedirect("registro.jsp?error=bibliotecario_existe");
                } else {
                    response.sendRedirect("registro.jsp?error=sistema&detalle=" + e.getMessage());
                }
            } else {
                response.sendRedirect("registro.jsp?error=sistema");
            }
        }
    }
}
