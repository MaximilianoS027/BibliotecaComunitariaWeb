package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.bibliotecario.BibliotecarioPublicadorService;
import publicadores.bibliotecario.BibliotecarioPublicador;
import publicadores.bibliotecario.BibliotecarioRepetidoException_Exception;
import publicadores.bibliotecario.DatosInvalidosException_Exception;

/**
 * Servlet para agregar nuevos bibliotecarios al sistema
 * Consume Web Service de bibliotecarios
 */
@WebServlet("/AgregarBibliotecario")
public class AgregarBibliotecarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BibliotecarioPublicador bibliotecarioWS;

    public AgregarBibliotecarioServlet() {
        super();
        bibliotecarioWS = new BibliotecarioPublicadorService().getBibliotecarioPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Verificar que el usuario esté autenticado como bibliotecario
        HttpSession session = request.getSession(false);
        if (session == null || !"BIBLIOTECARIO".equals(session.getAttribute("rol"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Redirigir al formulario de registro
        response.sendRedirect("agregarBibliotecario.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || !"BIBLIOTECARIO".equals(session.getAttribute("rol"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String email = request.getParameter("email");
        String nombre = request.getParameter("nombre");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        try {
            
            // Validaciones básicas
            if (email == null || email.trim().isEmpty() ||
                nombre == null || nombre.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                response.sendRedirect("agregarBibliotecario.jsp?error=campos_vacios");
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                response.sendRedirect("agregarBibliotecario.jsp?error=password_no_coincide");
                return;
            }
            
            // Registrar bibliotecario usando Web Service
            bibliotecarioWS.registrarBibliotecarioConPassword(email, nombre, password);
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("gestionBibliotecarios.jsp?success=bibliotecario_agregado");
            
        } catch (BibliotecarioRepetidoException_Exception e) {
            response.sendRedirect("agregarBibliotecario.jsp?error=bibliotecario_existe");
            
        } catch (DatosInvalidosException_Exception e) {
            response.sendRedirect("agregarBibliotecario.jsp?error=datos_invalidos");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("agregarBibliotecario.jsp?error=sistema");
        }
    }
}

