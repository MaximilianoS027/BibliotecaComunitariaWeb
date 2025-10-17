package servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;
import publicadores.libro.DtLibro;
import publicadores.libro.StringArray;

/**
 * Servlet para listar todos los libros del catálogo
 * Accesible para LECTOR y BIBLIOTECARIO
 */
@WebServlet("/ListarLibros")
public class ListarLibrosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroPublicador libroWS;

    public ListarLibrosServlet() {
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
        
        try {
            System.out.println("=== LISTAR LIBROS ===");
            
            // Obtener IDs de todos los libros
            StringArray stringArray = libroWS.listarLibros();
            List<String> idsLibros = stringArray != null ? stringArray.getItem() : new ArrayList<>();
            System.out.println("Total de libros encontrados: " + (idsLibros != null ? idsLibros.size() : 0));
            
            List<DtLibro> libros = new ArrayList<>();
            
            if (idsLibros != null && !idsLibros.isEmpty()) {
                // Obtener detalles de cada libro
                for (String item : idsLibros) {
                    try {
                        // El backend retorna: "ID | Título | Páginas | Fecha"
                        // Extraer solo el ID (primera parte)
                        String id = item;
                        if (item.contains(" | ")) {
                            String[] parts = item.split(" \\| ");
                            id = parts[0].trim();
                        }
                        
                        System.out.println("Obteniendo libro con ID: " + id);
                        DtLibro libro = libroWS.obtenerLibro(id);
                        if (libro != null) {
                            libros.add(libro);
                            System.out.println("Libro agregado: " + libro.getTitulo());
                        }
                    } catch (Exception e) {
                        System.out.println("Error al obtener libro " + item + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
            
            // Guardar lista en request
            request.setAttribute("libros", libros);
            request.setAttribute("totalLibros", libros.size());
            
            // Forward a catalogo.jsp
            request.getRequestDispatcher("catalogo.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en ListarLibrosServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el catálogo: " + e.getMessage());
            request.setAttribute("libros", new ArrayList<DtLibro>());
            request.getRequestDispatcher("catalogo.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

