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

/**
 * Servlet para consultar los detalles de un lector específico
 * Accesible para BIBLIOTECARIO y LECTOR (solo su propio perfil)
 */
@WebServlet("/ConsultarLector")
public class ConsultarLectorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LectorPublicador lectorWS;

    public ConsultarLectorServlet() {
        super();
        lectorWS = new LectorPublicadorService().getLectorPublicadorPort();
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
        String lectorId = request.getParameter("id");
        
        if (lectorId == null || lectorId.trim().isEmpty()) {
            response.sendRedirect("ListarLectores?error=id_invalido");
            return;
        }
        
        // Control de acceso: LECTOR solo puede ver su propio perfil
        if ("LECTOR".equals(rol)) {
            String usuarioId = (String) session.getAttribute("usuarioId");
            if (!lectorId.equals(usuarioId)) {
                response.sendRedirect("home.jsp?error=permisos");
                return;
            }
        }
        
        try {
            System.out.println("=== CONSULTAR LECTOR ===");
            System.out.println("ID: " + lectorId);
            
            // Obtener detalles del lector
            DtLector lector = lectorWS.obtenerLector(lectorId);
            
            if (lector != null) {
                request.setAttribute("lector", lector);
                request.getRequestDispatcher("perfilLector.jsp").forward(request, response);
            } else {
                response.sendRedirect("ListarLectores?error=lector_no_encontrado");
            }
            
        } catch (LectorNoExisteException_Exception e) {
            System.out.println("Error: Lector no existe - " + e.getMessage());
            response.sendRedirect("ListarLectores?error=lector_no_existe");
            
        } catch (Exception e) {
            System.out.println("ERROR en ConsultarLectorServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ListarLectores?error=consulta");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
