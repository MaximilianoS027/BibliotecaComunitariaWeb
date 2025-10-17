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
import publicadores.libro.LibroRepetidoException_Exception;
import publicadores.libro.DatosInvalidosException_Exception;

/**
 * Servlet para agregar nuevos libros al catálogo
 * Solo accesible para usuarios con rol BIBLIOTECARIO
 */
@WebServlet("/AgregarLibro")
public class AgregarLibroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroPublicador libroWS;

    public AgregarLibroServlet() {
        super();
        libroWS = new LibroPublicadorService().getLibroPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Verificar sesión y rol
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String rol = (String) session.getAttribute("rol");
        if (!"BIBLIOTECARIO".equals(rol)) {
            response.sendRedirect("home.jsp?error=permisos");
            return;
        }
        
        // Mostrar formulario
        request.getRequestDispatcher("agregarLibro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión y rol
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String rol = (String) session.getAttribute("rol");
        if (!"BIBLIOTECARIO".equals(rol)) {
            response.sendRedirect("home.jsp?error=permisos");
            return;
        }
        
        // Obtener parámetros del formulario
        String titulo = request.getParameter("titulo");
        String cantidadPaginasStr = request.getParameter("cantidadPaginas");
        
        try {
            // Validar datos básicos
            if (titulo == null || titulo.trim().isEmpty()) {
                request.setAttribute("error", "El título es obligatorio");
                request.getRequestDispatcher("agregarLibro.jsp").forward(request, response);
                return;
            }
            
            int cantidadPaginas;
            try {
                cantidadPaginas = Integer.parseInt(cantidadPaginasStr);
                if (cantidadPaginas <= 0) {
                    throw new NumberFormatException("Debe ser positivo");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "La cantidad de páginas debe ser un número positivo");
                request.setAttribute("titulo", titulo);
                request.getRequestDispatcher("agregarLibro.jsp").forward(request, response);
                return;
            }
            
            // Llamar al Web Service
            System.out.println("=== AGREGAR LIBRO ===");
            System.out.println("Título: " + titulo);
            System.out.println("Páginas: " + cantidadPaginas);
            
            libroWS.registrarLibro(titulo, cantidadPaginas);
            
            // Redirigir con mensaje de éxito al servlet (no directo al JSP)
            response.sendRedirect("ListarLibros?success=agregar");
            
        } catch (LibroRepetidoException_Exception e) {
            System.out.println("Error: Libro repetido - " + e.getMessage());
            request.setAttribute("error", "Ya existe un libro con ese título");
            request.setAttribute("titulo", titulo);
            request.setAttribute("cantidadPaginas", cantidadPaginasStr);
            request.getRequestDispatcher("agregarLibro.jsp").forward(request, response);
            
        } catch (DatosInvalidosException_Exception e) {
            System.out.println("Error: Datos inválidos - " + e.getMessage());
            request.setAttribute("error", "Los datos proporcionados no son válidos: " + e.getMessage());
            request.setAttribute("titulo", titulo);
            request.setAttribute("cantidadPaginas", cantidadPaginasStr);
            request.getRequestDispatcher("agregarLibro.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en AgregarLibroServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al agregar el libro: " + e.getMessage());
            request.setAttribute("titulo", titulo);
            request.setAttribute("cantidadPaginas", cantidadPaginasStr);
            request.getRequestDispatcher("agregarLibro.jsp").forward(request, response);
        }
    }
}

