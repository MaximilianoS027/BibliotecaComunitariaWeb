package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;
import publicadores.libro.DtLibro;
import publicadores.libro.LibroNoExisteException_Exception;

/**
 * Servlet para consultar los detalles de un libro específico
 * Accesible para LECTOR y BIBLIOTECARIO
 */
@WebServlet("/ConsultarLibro")
public class ConsultarLibroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroPublicador libroWS;

    public ConsultarLibroServlet() {
        super();
        libroWS = new LibroPublicadorService().getLibroPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String libroId = request.getParameter("id");
        
        if (libroId == null || libroId.trim().isEmpty()) {
            response.sendRedirect("ListarLibros?error=id_invalido");
            return;
        }
        
        try {
            System.out.println("=== CONSULTAR LIBRO ===");
            System.out.println("ID: " + libroId);
            
            // Obtener detalles del libro
            DtLibro libro = libroWS.obtenerLibro(libroId);
            
            if (libro != null) {
                request.setAttribute("libro", libro);
                request.getRequestDispatcher("detalleLibro.jsp").forward(request, response);
            } else {
                response.sendRedirect("ListarLibros?error=libro_no_encontrado");
            }
            
        } catch (LibroNoExisteException_Exception e) {
            System.out.println("Error: Libro no existe - " + e.getMessage());
            response.sendRedirect("ListarLibros?error=libro_no_existe");
            
        } catch (Exception e) {
            System.out.println("ERROR en ConsultarLibroServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ListarLibros?error=consulta");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

