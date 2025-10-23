package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.prestamo.DtPrestamo;

@WebServlet("/TestFechaPrestamo")
public class TestFechaPrestamoServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            PrestamoPublicadorService service = new PrestamoPublicadorService();
            PrestamoPublicador prestamoWS = service.getPrestamoPublicadorPort();
            
            // Obtener un préstamo existente (ej. P1 que sabemos que está DEVUELTO)
            DtPrestamo prestamo = prestamoWS.obtenerPrestamo("P1");
            
            response.getWriter().println("<h1>Diagnóstico de Formato de Fecha</h1>");
            response.getWriter().println("<h2>Préstamo P1 (DEVUELTO):</h2>");
            response.getWriter().println("<ul>");
            response.getWriter().println("<li><strong>ID:</strong> " + prestamo.getId() + "</li>");
            response.getWriter().println("<li><strong>Estado:</strong> " + prestamo.getEstado() + "</li>");
            
            // Fecha de Solicitud
            Object fechaSolicitud = prestamo.getFechaSolicitud();
            response.getWriter().println("<li><strong>Fecha Solicitud (tipo):</strong> " + 
                (fechaSolicitud != null ? fechaSolicitud.getClass().getName() : "null") + "</li>");
            response.getWriter().println("<li><strong>Fecha Solicitud (valor):</strong> " + 
                (fechaSolicitud != null ? fechaSolicitud.toString() : "null") + "</li>");
            
            // Fecha de Devolución
            Object fechaDevolucion = prestamo.getFechaDevolucion();
            response.getWriter().println("<li><strong>Fecha Devolución (tipo):</strong> " + 
                (fechaDevolucion != null ? fechaDevolucion.getClass().getName() : "null") + "</li>");
            response.getWriter().println("<li><strong>Fecha Devolución (valor):</strong> " + 
                (fechaDevolucion != null ? fechaDevolucion.toString() : "null") + "</li>");
            
            response.getWriter().println("</ul>");
            
            // Probar con otro préstamo
            try {
                DtPrestamo prestamo2 = prestamoWS.obtenerPrestamo("P3");
                response.getWriter().println("<h2>Préstamo P3 (DEVUELTO):</h2>");
                response.getWriter().println("<ul>");
                response.getWriter().println("<li><strong>ID:</strong> " + prestamo2.getId() + "</li>");
                response.getWriter().println("<li><strong>Estado:</strong> " + prestamo2.getEstado() + "</li>");
                
                Object fechaDev2 = prestamo2.getFechaDevolucion();
                response.getWriter().println("<li><strong>Fecha Devolución (tipo):</strong> " + 
                    (fechaDev2 != null ? fechaDev2.getClass().getName() : "null") + "</li>");
                response.getWriter().println("<li><strong>Fecha Devolución (valor):</strong> " + 
                    (fechaDev2 != null ? fechaDev2.toString() : "null") + "</li>");
                response.getWriter().println("</ul>");
            } catch (Exception e) {
                response.getWriter().println("<p>Error al obtener P3: " + e.getMessage() + "</p>");
            }
            
        } catch (Exception e) {
            response.getWriter().println("<h1>Error al obtener préstamo</h1>");
            response.getWriter().println("<p style='color: red;'>" + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
        }
    }
}
