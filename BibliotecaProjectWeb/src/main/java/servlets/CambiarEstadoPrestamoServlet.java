package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.prestamo.PrestamoNoExisteException_Exception;
import publicadores.prestamo.DatosInvalidosException_Exception;

/**
 * Servlet para cambiar el estado de un préstamo
 * Solo accesible para BIBLIOTECARIO
 */
@WebServlet("/CambiarEstadoPrestamo")
public class CambiarEstadoPrestamoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrestamoPublicador prestamoWS;

    public CambiarEstadoPrestamoServlet() {
        super();
        prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
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
        
        // Obtener parámetros
        String prestamoId = request.getParameter("id");
        String nuevoEstado = request.getParameter("estado");
        
        try {
            // Validar datos básicos
            if (prestamoId == null || prestamoId.trim().isEmpty()) {
                response.sendRedirect("ListarPrestamos?error=id_invalido");
                return;
            }
            
            if (nuevoEstado == null || nuevoEstado.trim().isEmpty()) {
                response.sendRedirect("ListarPrestamos?error=estado_invalido");
                return;
            }
            
            // Llamar al Web Service
            System.out.println("=== CAMBIAR ESTADO PRÉSTAMO ===");
            System.out.println("ID: " + prestamoId);
            System.out.println("Nuevo Estado: " + nuevoEstado);
            
            prestamoWS.cambiarEstadoPrestamo(prestamoId, nuevoEstado);
            
            System.out.println("✅ Estado del préstamo cambiado exitosamente a: " + nuevoEstado);
            
            // Redirigir con mensaje de éxito y timestamp para evitar caché
            response.sendRedirect("ListarPrestamos?success=estado_cambiado&t=" + System.currentTimeMillis());
            
        } catch (PrestamoNoExisteException_Exception e) {
            System.out.println("❌ Error: Préstamo no existe - " + e.getMessage());
            response.sendRedirect("ListarPrestamos?error=prestamo_no_existe");
            
        } catch (DatosInvalidosException_Exception e) {
            System.out.println("❌ Error: Estado inválido - " + e.getMessage());
            response.sendRedirect("ListarPrestamos?error=estado_invalido");
            
        } catch (Exception e) {
            System.out.println("❌ ERROR en CambiarEstadoPrestamoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ListarPrestamos?error=cambio_estado");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
