package servlets;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import publicadores.prestamo.DatosInvalidosException_Exception;

/**
 * Servlet para devolver préstamos
 * Accesible para usuarios con rol LECTOR (sus propios préstamos) y BIBLIOTECARIO (cualquier préstamo)
 */
@WebServlet("/DevolverPrestamo")
public class DevolverPrestamoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrestamoPublicador prestamoWS;

    public DevolverPrestamoServlet() {
        super();
        prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // CONFIGURAR CODIFICACIÓN UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Verificar sesión y rol
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String rol = (String) session.getAttribute("rol");
        if (!"LECTOR".equals(rol) && !"BIBLIOTECARIO".equals(rol)) {
            response.sendRedirect("home.jsp?error=permisos");
            return;
        }
        
        String prestamoId = request.getParameter("id");
        
        if (prestamoId == null || prestamoId.trim().isEmpty()) {
            if ("BIBLIOTECARIO".equals(rol)) {
                response.sendRedirect("ListarPrestamos?error=id_invalido");
            } else {
                response.sendRedirect("MisPrestamos?error=id_invalido");
            }
            return;
        }
        
        try {
            // Verificar que el préstamo existe
            DtPrestamo prestamo = prestamoWS.obtenerPrestamo(prestamoId);
            String usuarioId = (String) session.getAttribute("usuarioId");
            
            // Si es LECTOR, verificar que el préstamo le pertenece
            if ("LECTOR".equals(rol) && !prestamo.getLectorId().equals(usuarioId)) {
                response.sendRedirect("home.jsp?error=permisos");
                return;
            }
            
            // Verificar que el préstamo puede ser devuelto
            if (!"En Uso".equals(prestamo.getEstado()) && !"EN_CURSO".equals(prestamo.getEstado())) {
                String redirectUrl = "BIBLIOTECARIO".equals(rol) ? "ListarPrestamos" : "ConsultarPrestamo?id=" + prestamoId;
                response.sendRedirect(redirectUrl + "?error=no_devuelto");
                return;
            }
            
            // Generar fecha de devolución actual
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String fechaDevolucion = sdf.format(new Date());
            
            // Llamar al Web Service
            prestamoWS.devolverPrestamo(prestamoId, fechaDevolucion);
            
            // Redirigir con mensaje de éxito según el rol
            String redirectUrl = "BIBLIOTECARIO".equals(rol) ? "ListarPrestamos" : "MisPrestamos";
            response.sendRedirect(redirectUrl + "?success=devolucion_exitosa&t=" + System.currentTimeMillis());
            
        } catch (PrestamoNoExisteException_Exception e) {
            response.sendRedirect("MisPrestamos?error=prestamo_no_existe");
            
        } catch (DatosInvalidosException_Exception e) {
            response.sendRedirect("MisPrestamos?error=devolucion_invalida");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MisPrestamos?error=devolucion");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
