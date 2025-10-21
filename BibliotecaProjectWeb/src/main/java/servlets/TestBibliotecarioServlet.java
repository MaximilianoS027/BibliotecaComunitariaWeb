package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import publicadores.bibliotecario.BibliotecarioPublicadorService;
import publicadores.bibliotecario.BibliotecarioPublicador;

@WebServlet("/TestBibliotecario")
public class TestBibliotecarioServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Crear instancia del Web Service
            BibliotecarioPublicadorService service = new BibliotecarioPublicadorService();
            BibliotecarioPublicador bibliotecarioWS = service.getBibliotecarioPublicadorPort();
            
            response.getWriter().println("<h1>Prueba de Web Service de Bibliotecarios</h1>");
            
            // Listar todos los bibliotecarios
            response.getWriter().println("<h2>Listando todos los bibliotecarios:</h2>");
            try {
                publicadores.bibliotecario.StringArray bibliotecariosArray = bibliotecarioWS.listarBibliotecarios();
                if (bibliotecariosArray != null && bibliotecariosArray.getItem() != null) {
                    response.getWriter().println("<ul>");
                    for (String item : bibliotecariosArray.getItem()) {
                        response.getWriter().println("<li>" + item + "</li>");
                    }
                    response.getWriter().println("</ul>");
                } else {
                    response.getWriter().println("<p>No hay bibliotecarios disponibles</p>");
                }
            } catch (Exception e) {
                response.getWriter().println("<p style='color: red;'>Error al listar bibliotecarios: " + e.getMessage() + "</p>");
            }
            
        } catch (Exception e) {
            response.getWriter().println("<h1>Error al conectar con Web Service de Bibliotecarios</h1>");
            response.getWriter().println("<p style='color: red;'>" + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
        }
    }
}
