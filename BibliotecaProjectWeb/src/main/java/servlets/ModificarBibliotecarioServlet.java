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
import publicadores.bibliotecario.DtBibliotecario;
import publicadores.bibliotecario.BibliotecarioNoExisteException_Exception;

/**
 * Servlet para modificar datos de bibliotecarios
 * Consume Web Service de bibliotecarios
 */
@WebServlet("/ModificarBibliotecario")
public class ModificarBibliotecarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BibliotecarioPublicador bibliotecarioWS;

    public ModificarBibliotecarioServlet() {
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
        
        String email = request.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("gestionBibliotecarios.jsp?error=email_requerido");
            return;
        }
        
        try {
            
            // Obtener datos del bibliotecario usando Web Service
            DtBibliotecario bibliotecario = bibliotecarioWS.obtenerBibliotecario(email);
            
            
            // Pasar los datos a la vista
            request.setAttribute("bibliotecario", bibliotecario);
            request.setAttribute("modo", "editar");
            
            // Redirigir al formulario de edición
            request.getRequestDispatcher("editarBibliotecario.jsp").forward(request, response);
            
        } catch (BibliotecarioNoExisteException_Exception e) {
            response.sendRedirect("gestionBibliotecarios.jsp?error=bibliotecario_no_existe");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("gestionBibliotecarios.jsp?error=sistema");
        }
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
        String numeroEmpleado = request.getParameter("numeroEmpleado");
        
        try {
            
            // Validaciones básicas
            if (email == null || email.trim().isEmpty() ||
                nombre == null || nombre.trim().isEmpty()) {
                response.sendRedirect("editarBibliotecario.jsp?error=campos_vacios&email=" + email);
                return;
            }
            
            // Obtener bibliotecario actual
            DtBibliotecario bibliotecario = bibliotecarioWS.obtenerBibliotecario(email);
            
            // Actualizar datos
            bibliotecario.setNombre(nombre);
            if (numeroEmpleado != null && !numeroEmpleado.trim().isEmpty()) {
                bibliotecario.setNumeroEmpleado(numeroEmpleado);
            }
            
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("gestionBibliotecarios.jsp?success=bibliotecario_modificado");
            
        } catch (BibliotecarioNoExisteException_Exception e) {
            response.sendRedirect("gestionBibliotecarios.jsp?error=bibliotecario_no_existe");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("editarBibliotecario.jsp?error=sistema&email=" + email);
        }
    }
}

