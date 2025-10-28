package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import logica.WebServiceFactory;
import publicadores.libro.LibroPublicador;
import publicadores.libro.DtLibro;
import publicadores.libro.LibroNoExisteException_Exception;

/**
 * Servlet para consultar los detalles de un libro específico
 * Accesible para LECTOR y BIBLIOTECARIO
 */
@WebServlet("/ConsultarLibro")
public class ConsultarLibroServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Configurar codificación
        setupEncoding(request, response);
        
        // Obtener parámetros
        String libroId = request.getParameter("id");
        
        if (libroId == null || libroId.trim().isEmpty()) {
            forwardToError(request, response, "ID de libro no especificado");
            return;
        }
        
        try {
            logInfo("Consultando detalles del libro: " + libroId);
            
            // Obtener servicio y consultar detalles del libro
            LibroPublicador libroWS = WebServiceFactory.getLibroService();
            DtLibro libro = libroWS.obtenerLibro(libroId);
            
            if (libro == null) {
                request.setAttribute("error", "Libro no encontrado con ID: " + libroId);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            logInfo("Libro encontrado: " + libro.getTitulo());
            
            // Guardar datos en request
            request.setAttribute("libro", libro);
            
            // Obtener rol del usuario para mostrar opciones apropiadas
            String rol = getUserRole(request);
            if (rol == null) {
                rol = "INVITADO";
            }
            request.setAttribute("rol", rol);
            
            // Forward a la JSP
            request.getRequestDispatcher("detalleLibro.jsp").forward(request, response);
            
        } catch (LibroNoExisteException_Exception e) {
            logError("Libro no existe: " + libroId, e);
            forwardToError(request, response, "El libro con ID '" + libroId + "' no existe en el sistema");
            
        } catch (Exception e) {
            logError("Error al consultar libro: " + e.getMessage(), e);
            forwardToError(request, response, "Error interno del servidor: " + e.getMessage());
        }
    }
}

