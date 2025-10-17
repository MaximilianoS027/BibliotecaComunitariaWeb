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
import publicadores.libro.DatosInvalidosException_Exception;

/**
 * Servlet para modificar los datos de un libro existente
 * Solo accesible para usuarios con rol BIBLIOTECARIO
 */
@WebServlet("/ModificarLibro")
public class ModificarLibroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroPublicador libroWS;

    public ModificarLibroServlet() {
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
        
        String libroId = request.getParameter("id");
        
        if (libroId == null || libroId.trim().isEmpty()) {
            response.sendRedirect("ListarLibros?error=id_invalido");
            return;
        }
        
        try {
            // Obtener datos actuales del libro
            DtLibro libro = libroWS.obtenerLibro(libroId);
            
            if (libro != null) {
                request.setAttribute("libro", libro);
                request.getRequestDispatcher("editarLibro.jsp").forward(request, response);
            } else {
                response.sendRedirect("ListarLibros?error=libro_no_encontrado");
            }
            
        } catch (LibroNoExisteException_Exception e) {
            System.out.println("Error: Libro no existe - " + e.getMessage());
            response.sendRedirect("ListarLibros?error=libro_no_existe");
            
        } catch (Exception e) {
            System.out.println("ERROR en ModificarLibroServlet (GET): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ListarLibros?error=modificar");
        }
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
        String libroId = request.getParameter("id");
        String titulo = request.getParameter("titulo");
        String cantidadPaginasStr = request.getParameter("cantidadPaginas");
        
        try {
            // Validar datos básicos
            if (libroId == null || libroId.trim().isEmpty()) {
                response.sendRedirect("ListarLibros?error=id_invalido");
                return;
            }
            
            if (titulo == null || titulo.trim().isEmpty()) {
                DtLibro libro = libroWS.obtenerLibro(libroId);
                request.setAttribute("error", "El título es obligatorio");
                request.setAttribute("libro", libro);
                request.getRequestDispatcher("editarLibro.jsp").forward(request, response);
                return;
            }
            
            int cantidadPaginas;
            try {
                cantidadPaginas = Integer.parseInt(cantidadPaginasStr);
                if (cantidadPaginas <= 0) {
                    throw new NumberFormatException("Debe ser positivo");
                }
            } catch (NumberFormatException e) {
                DtLibro libro = libroWS.obtenerLibro(libroId);
                libro.setTitulo(titulo);
                request.setAttribute("error", "La cantidad de páginas debe ser un número positivo");
                request.setAttribute("libro", libro);
                request.getRequestDispatcher("editarLibro.jsp").forward(request, response);
                return;
            }
            
            // Llamar al Web Service
            System.out.println("=== MODIFICAR LIBRO ===");
            System.out.println("ID: " + libroId);
            System.out.println("Nuevo Título: " + titulo);
            System.out.println("Nuevas Páginas: " + cantidadPaginas);
            
            libroWS.actualizarLibro(libroId, titulo, cantidadPaginas);
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("ConsultarLibro?id=" + libroId + "&success=modificar");
            
        } catch (LibroNoExisteException_Exception e) {
            System.out.println("Error: Libro no existe - " + e.getMessage());
            response.sendRedirect("ListarLibros?error=libro_no_existe");
            
        } catch (DatosInvalidosException_Exception e) {
            System.out.println("Error: Datos inválidos - " + e.getMessage());
            try {
                DtLibro libro = libroWS.obtenerLibro(libroId);
                libro.setTitulo(titulo);
                libro.setCantidadPaginas(Integer.parseInt(cantidadPaginasStr));
                request.setAttribute("error", "Los datos proporcionados no son válidos: " + e.getMessage());
                request.setAttribute("libro", libro);
                request.getRequestDispatcher("editarLibro.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendRedirect("ListarLibros?error=modificar");
            }
            
        } catch (Exception e) {
            System.out.println("ERROR en ModificarLibroServlet (POST): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ListarLibros?error=modificar");
        }
    }
}

