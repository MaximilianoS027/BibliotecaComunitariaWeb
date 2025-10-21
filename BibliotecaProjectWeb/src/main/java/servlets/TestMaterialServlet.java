package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;
import publicadores.articuloespecial.ArticuloEspecialPublicador;

@WebServlet("/TestMaterial")
public class TestMaterialServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            response.getWriter().println("<h1>Prueba de Web Service de Materiales</h1>");
            
            // Probar libros
            response.getWriter().println("<h2>Libros disponibles:</h2>");
            try {
                LibroPublicadorService libroService = new LibroPublicadorService();
                LibroPublicador libroWS = libroService.getLibroPublicadorPort();
                
                publicadores.libro.StringArray librosArray = libroWS.listarLibros();
                if (librosArray != null && librosArray.getItem() != null) {
                    response.getWriter().println("<ul>");
                    for (String item : librosArray.getItem()) {
                        response.getWriter().println("<li>" + item + "</li>");
                    }
                    response.getWriter().println("</ul>");
                } else {
                    response.getWriter().println("<p>No hay libros disponibles</p>");
                }
            } catch (Exception e) {
                response.getWriter().println("<p style='color: red;'>Error al listar libros: " + e.getMessage() + "</p>");
            }
            
            // Probar artículos especiales
            response.getWriter().println("<h2>Artículos especiales disponibles:</h2>");
            try {
                ArticuloEspecialPublicadorService articuloService = new ArticuloEspecialPublicadorService();
                ArticuloEspecialPublicador articuloWS = articuloService.getArticuloEspecialPublicadorPort();
                
                publicadores.articuloespecial.StringArray articulosArray = articuloWS.listarArticulosEspeciales();
                if (articulosArray != null && articulosArray.getItem() != null) {
                    response.getWriter().println("<ul>");
                    for (String item : articulosArray.getItem()) {
                        response.getWriter().println("<li>" + item + "</li>");
                    }
                    response.getWriter().println("</ul>");
                } else {
                    response.getWriter().println("<p>No hay artículos especiales disponibles</p>");
                }
            } catch (Exception e) {
                response.getWriter().println("<p style='color: red;'>Error al listar artículos: " + e.getMessage() + "</p>");
            }
            
        } catch (Exception e) {
            response.getWriter().println("<h1>Error al conectar con Web Services</h1>");
            response.getWriter().println("<p style='color: red;'>" + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
        }
    }
}
