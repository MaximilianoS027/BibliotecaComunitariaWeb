package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.lector.LectorPublicadorService;
import publicadores.lector.LectorPublicador;
import publicadores.lector.DtLector;
import publicadores.lector.LectorNoExisteException_Exception;
import publicadores.lector.DatosInvalidosException_Exception;

/**
 * Servlet para cambiar el estado de un lector
 * Solo accesible para usuarios con rol BIBLIOTECARIO
 */
@WebServlet("/CambiarEstadoLector")
public class CambiarEstadoLectorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LectorPublicador lectorWS;

    public CambiarEstadoLectorServlet() {
        super();
        lectorWS = new LectorPublicadorService().getLectorPublicadorPort();
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
        
        String lectorId = request.getParameter("id");
        
        if (lectorId == null || lectorId.trim().isEmpty()) {
            response.sendRedirect("ListarLectores?error=id_invalido");
            return;
        }
        
        try {
            // Obtener datos actuales del lector
            DtLector lector = lectorWS.obtenerLector(lectorId);
            
            if (lector != null) {
                request.setAttribute("lector", lector);
                request.getRequestDispatcher("cambiarEstadoLector.jsp").forward(request, response);
            } else {
                response.sendRedirect("ListarLectores?error=lector_no_encontrado");
            }
            
        } catch (LectorNoExisteException_Exception e) {
            System.out.println("Error: Lector no existe - " + e.getMessage());
            response.sendRedirect("ListarLectores?error=lector_no_existe");
            
        } catch (Exception e) {
            System.out.println("ERROR en CambiarEstadoLectorServlet (GET): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ListarLectores?error=consulta");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
        
        // Obtener parámetros del formulario
        String lectorId = request.getParameter("id");
        String nuevoEstado = request.getParameter("nuevoEstado");
        
        try {
            // Validar datos básicos
            if (lectorId == null || lectorId.trim().isEmpty()) {
                response.sendRedirect("ListarLectores?error=id_invalido");
                return;
            }
            
            if (nuevoEstado == null || nuevoEstado.trim().isEmpty()) {
                DtLector lector = lectorWS.obtenerLector(lectorId);
                request.setAttribute("error", "El estado es obligatorio");
                request.setAttribute("lector", lector);
                request.getRequestDispatcher("cambiarEstadoLector.jsp").forward(request, response);
                return;
            }
            
            // Llamar al Web Service
            System.out.println("=== CAMBIAR ESTADO LECTOR ===");
            System.out.println("ID: " + lectorId);
            System.out.println("Nuevo Estado: " + nuevoEstado);
            
            lectorWS.cambiarEstadoLector(lectorId, nuevoEstado);
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("ConsultarLector?id=" + lectorId + "&success=estado_cambiado");
            
        } catch (LectorNoExisteException_Exception e) {
            System.out.println("Error: Lector no existe - " + e.getMessage());
            response.sendRedirect("ListarLectores?error=lector_no_existe");
            
        } catch (DatosInvalidosException_Exception e) {
            System.out.println("Error: Estado inválido - " + e.getMessage());
            try {
                DtLector lector = lectorWS.obtenerLector(lectorId);
                request.setAttribute("error", "El estado proporcionado no es válido: " + e.getMessage());
                request.setAttribute("lector", lector);
                request.getRequestDispatcher("cambiarEstadoLector.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendRedirect("ListarLectores?error=estado_invalido");
            }
            
        } catch (Exception e) {
            System.out.println("ERROR en CambiarEstadoLectorServlet (POST): " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ListarLectores?error=cambio_estado");
        }
    }
}
