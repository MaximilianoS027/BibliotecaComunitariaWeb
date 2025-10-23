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
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;
import publicadores.articuloespecial.ArticuloEspecialPublicador;
import publicadores.articuloespecial.DtArticuloEspecial;
import publicadores.articuloespecial.StringArray;

/**
 * Servlet para listar todos los artículos especiales del catálogo
 * Accesible para LECTOR y BIBLIOTECARIO
 */
@WebServlet("/ListarArticulosEspeciales")
public class ListarArticulosEspecialesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ArticuloEspecialPublicador articuloEspecialWS;

    public ListarArticulosEspecialesServlet() {
        super();
        articuloEspecialWS = new ArticuloEspecialPublicadorService().getArticuloEspecialPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // CONFIGURAR CODIFICACIÓN UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            System.out.println("=== LISTAR ARTÍCULOS ESPECIALES ===");
            
            // Obtener lista de artículos especiales
            StringArray stringArray = articuloEspecialWS.listarArticulosEspeciales();
            List<String> idsArticulos = stringArray != null ? stringArray.getItem() : new ArrayList<>();
            System.out.println("Total de artículos especiales encontrados: " + (idsArticulos != null ? idsArticulos.size() : 0));
            
            List<DtArticuloEspecial> articulos = new ArrayList<>();
            
            if (idsArticulos != null && !idsArticulos.isEmpty()) {
                // Obtener detalles de cada artículo especial
                for (String item : idsArticulos) {
                    try {
                        // El backend retorna: "ID | Descripción | Peso | Dimensiones | Fecha"
                        // Extraer solo el ID (primera parte)
                        String id = item;
                        if (item.contains(" | ")) {
                            String[] parts = item.split(" \\| ");
                            id = parts[0].trim();
                        }
                        
                        System.out.println("Obteniendo artículo especial con ID: " + id);
                        DtArticuloEspecial articulo = articuloEspecialWS.obtenerArticuloEspecial(id);
                        if (articulo != null) {
                            articulos.add(articulo);
                            System.out.println("Artículo especial agregado: " + articulo.getDescripcion());
                        }
                    } catch (Exception e) {
                        System.out.println("Error al obtener artículo especial " + item + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
            
            // Guardar lista en request
            request.setAttribute("articulos", articulos);
            request.setAttribute("totalArticulos", articulos.size());
            
            // Forward a catalogoArticulosEspeciales.jsp
            request.getRequestDispatcher("catalogoArticulosEspeciales.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en ListarArticulosEspecialesServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el catálogo: " + e.getMessage());
            request.setAttribute("articulos", new ArrayList<DtArticuloEspecial>());
            request.getRequestDispatcher("catalogoArticulosEspeciales.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

