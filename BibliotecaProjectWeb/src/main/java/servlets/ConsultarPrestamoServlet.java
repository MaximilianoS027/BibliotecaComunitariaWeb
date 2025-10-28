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
import publicadores.prestamo.DtPrestamo;
import publicadores.prestamo.PrestamoNoExisteException_Exception;

/**
 * Servlet para consultar los detalles de un préstamo específico
 * Accesible para LECTOR (solo sus propios préstamos) y BIBLIOTECARIO
 */
@WebServlet("/ConsultarPrestamo")
public class ConsultarPrestamoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrestamoPublicador prestamoWS;

    public ConsultarPrestamoServlet() {
        super();
        prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String rol = (String) session.getAttribute("rol");
        String prestamoId = request.getParameter("id");
        
        if (prestamoId == null || prestamoId.trim().isEmpty()) {
            response.sendRedirect("MisPrestamos?error=id_invalido");
            return;
        }
        
        try {
            // Obtener detalles del préstamo
            DtPrestamo prestamo = prestamoWS.obtenerPrestamo(prestamoId);
            
            if (prestamo != null) {
                // Control de acceso: LECTOR solo puede ver sus propios préstamos
                if ("LECTOR".equals(rol)) {
                    String usuarioId = (String) session.getAttribute("usuarioId");
                    if (!prestamo.getLectorId().equals(usuarioId)) {
                        response.sendRedirect("home.jsp?error=permisos");
                        return;
                    }
                }
                
                request.setAttribute("prestamo", prestamo);
                request.getRequestDispatcher("detallePrestamo.jsp").forward(request, response);
            } else {
                response.sendRedirect("MisPrestamos?error=prestamo_no_encontrado");
            }
            
        } catch (PrestamoNoExisteException_Exception e) {
            response.sendRedirect("MisPrestamos?error=prestamo_no_existe");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MisPrestamos?error=consulta");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
