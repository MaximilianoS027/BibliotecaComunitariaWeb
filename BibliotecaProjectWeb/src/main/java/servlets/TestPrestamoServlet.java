package servlets;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.prestamo.DatosInvalidosException_Exception;

@WebServlet("/TestPrestamo")
public class TestPrestamoServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Crear instancia del Web Service
            PrestamoPublicadorService service = new PrestamoPublicadorService();
            PrestamoPublicador prestamoWS = service.getPrestamoPublicadorPort();
            
            // Parámetros de prueba - usando IDs reales del sistema
            String lectorId = "L1"; // ID real de pedro gomez
            String bibliotecarioId = "B1"; // ID real de ivan cardozo
            String materialId = "MATB78AFBBF"; // ID real de "pepe y los globos"
            String estado = "EN_CURSO"; // valores válidos: PENDIENTE, EN_CURSO, DEVUELTO
            String fechaSolicitud = new SimpleDateFormat("dd/MM/yyyy").format(new Date());
            
            response.getWriter().println("<h1>Prueba de Web Service de Préstamos</h1>");
            response.getWriter().println("<h2>Parámetros:</h2>");
            response.getWriter().println("<ul>");
            response.getWriter().println("<li>Lector ID: " + lectorId + "</li>");
            response.getWriter().println("<li>Bibliotecario ID: " + bibliotecarioId + "</li>");
            response.getWriter().println("<li>Material ID: " + materialId + "</li>");
            response.getWriter().println("<li>Estado: " + estado + "</li>");
            response.getWriter().println("<li>Fecha: " + fechaSolicitud + "</li>");
            response.getWriter().println("</ul>");
            
            response.getWriter().println("<h2>Intentando registrar préstamo...</h2>");
            
            try {
                prestamoWS.registrarPrestamo(lectorId, bibliotecarioId, materialId, fechaSolicitud, estado);
                response.getWriter().println("<p style='color: green;'>✅ Préstamo registrado exitosamente!</p>");
            } catch (DatosInvalidosException_Exception e) {
                response.getWriter().println("<p style='color: red;'>❌ Error de datos inválidos: " + e.getMessage() + "</p>");
            } catch (Exception e) {
                response.getWriter().println("<p style='color: red;'>❌ Error general: " + e.getMessage() + "</p>");
                response.getWriter().println("<pre>" + e.toString() + "</pre>");
            }
            
        } catch (Exception e) {
            response.getWriter().println("<h1>Error al conectar con Web Service</h1>");
            response.getWriter().println("<p style='color: red;'>" + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
        }
    }
}
