package servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
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
 * Servlet para listar todos los lectores
 * Solo accesible para usuarios con rol BIBLIOTECARIO
 */
@WebServlet("/ListarLectores")
public class ListarLectoresServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LectorPublicador lectorWS;

    public ListarLectoresServlet() {
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
        
        try {
            System.out.println("=== LISTAR LECTORES ===");
            
            // Obtener filtro de estado si existe
            String filtroEstado = request.getParameter("estado");
            
            // Obtener IDs de todos los lectores
            publicadores.lector.StringArray idsLectoresArray;
            if (filtroEstado != null && !filtroEstado.trim().isEmpty()) {
                idsLectoresArray = lectorWS.listarLectoresPorEstado(filtroEstado);
                System.out.println("Filtro por estado: " + filtroEstado);
            } else {
                idsLectoresArray = lectorWS.listarLectores();
            }
            
            // Convertir StringArray a String[]
            String[] idsLectores = null;
            if (idsLectoresArray != null && idsLectoresArray.getItem() != null) {
                idsLectores = idsLectoresArray.getItem().toArray(new String[0]);
            }
            
            System.out.println("Total de lectores encontrados: " + (idsLectores != null ? idsLectores.length : 0));
            
            List<DtLector> lectores = new ArrayList<>();
            
            if (idsLectores != null && idsLectores.length > 0) {
                // Obtener detalles de cada lector
                for (String item : idsLectores) {
                    try {
                        // Extraer solo el ID de la cadena (formato: "ID - nombre (email)")
                        String id = item;
                        if (item.contains(" - ")) {
                            String[] parts = item.split(" - ");
                            id = parts[0].trim();
                        }
                        
                        System.out.println("Obteniendo lector con ID: " + id);
                        DtLector lector = lectorWS.obtenerLector(id);
                        if (lector != null) {
                            lectores.add(lector);
                            System.out.println("Lector agregado: " + lector.getNombre());
                        }
                    } catch (Exception e) {
                        System.out.println("Error al obtener lector " + item + ": " + e.getMessage());
                        // Continuar con el siguiente lector en caso de error
                    }
                }
            }
            
            // Guardar lista en request
            request.setAttribute("lectores", lectores);
            request.setAttribute("totalLectores", lectores.size());
            request.setAttribute("filtroEstado", filtroEstado);
            
            // Forward a gestionLectores.jsp
            request.getRequestDispatcher("gestionLectores.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en ListarLectoresServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar la lista de lectores: " + e.getMessage());
            request.setAttribute("lectores", new ArrayList<DtLector>());
            request.getRequestDispatcher("gestionLectores.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
