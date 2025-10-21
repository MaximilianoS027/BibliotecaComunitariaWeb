package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import publicadores.lector.LectorPublicadorService;
import publicadores.lector.LectorPublicador;

@WebServlet("/TestLector")
public class TestLectorServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Crear instancia del Web Service
            LectorPublicadorService service = new LectorPublicadorService();
            LectorPublicador lectorWS = service.getLectorPublicadorPort();
            
            response.getWriter().println("<h1>Prueba de Web Service de Lectores</h1>");
            
            // Listar todos los lectores
            response.getWriter().println("<h2>Listando todos los lectores:</h2>");
            try {
                publicadores.lector.StringArray lectoresArray = lectorWS.listarLectores();
                if (lectoresArray != null && lectoresArray.getItem() != null) {
                    response.getWriter().println("<ul>");
                    for (String item : lectoresArray.getItem()) {
                        response.getWriter().println("<li>" + item + "</li>");
                    }
                    response.getWriter().println("</ul>");
                } else {
                    response.getWriter().println("<p>No hay lectores disponibles</p>");
                }
            } catch (Exception e) {
                response.getWriter().println("<p style='color: red;'>Error al listar lectores: " + e.getMessage() + "</p>");
            }
            
        } catch (Exception e) {
            response.getWriter().println("<h1>Error al conectar con Web Service de Lectores</h1>");
            response.getWriter().println("<p style='color: red;'>" + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
        }
    }
}
