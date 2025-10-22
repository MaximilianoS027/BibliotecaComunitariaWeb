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
import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.prestamo.DtPrestamo;
import publicadores.prestamo.StringArray;
import publicadores.prestamo.PrestamoNoExisteException_Exception;

/**
 * Servlet para listar los préstamos del lector actual
 * Solo accesible para usuarios con rol LECTOR
 */
@WebServlet("/MisPrestamos")
public class MisPrestamosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrestamoPublicador prestamoWS;

    public MisPrestamosServlet() {
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
        if (!"LECTOR".equals(rol)) {
            response.sendRedirect("home.jsp?error=permisos");
            return;
        }
        
        String lectorId = (String) session.getAttribute("usuarioId");
        
        try {
            System.out.println("=== MIS PRÉSTAMOS ===");
            System.out.println("Lector ID: " + lectorId);
            
            // Obtener filtro de estado si existe
            String filtroEstado = request.getParameter("estado");
            System.out.println("Filtro de estado recibido: " + filtroEstado);
            
            // Obtener IDs de préstamos del lector
            StringArray prestamosArray = prestamoWS.listarPrestamosPorLector(lectorId);
            
            // Convertir StringArray a List<String>
            List<String> idsPrestamos = new ArrayList<>();
            if (prestamosArray != null && prestamosArray.getItem() != null) {
                idsPrestamos = prestamosArray.getItem();
            }
            
            System.out.println("Total de préstamos encontrados: " + idsPrestamos.size());
            
            List<DtPrestamo> prestamos = new ArrayList<>();
            
            if (!idsPrestamos.isEmpty()) {
                // Obtener detalles de cada préstamo
                for (String idCompleto : idsPrestamos) {
                    String idSolo = null;
                    try {
                        // Extraer solo el ID del préstamo (primera parte antes del " - ")
                        idSolo = idCompleto.split(" - ")[0].trim();
                        System.out.println("ID completo: " + idCompleto);
                        System.out.println("ID extraído: " + idSolo);
                        DtPrestamo prestamo = prestamoWS.obtenerPrestamo(idSolo);
                        if (prestamo != null) {
                            System.out.println("Préstamo " + prestamo.getId() + " estado: " + prestamo.getEstado());
                            // Aplicar filtro de estado si existe
                            if (filtroEstado == null || filtroEstado.trim().isEmpty() || 
                                filtroEstado.equals(prestamo.getEstado())) {
                                prestamos.add(prestamo);
                                System.out.println("✅ Préstamo agregado: " + prestamo.getId() + " (estado: " + prestamo.getEstado() + ")");
                            } else {
                                System.out.println("❌ Préstamo filtrado: " + prestamo.getId() + " (estado: " + prestamo.getEstado() + " != filtro: " + filtroEstado + ")");
                            }
                        }
                    } catch (PrestamoNoExisteException_Exception e) {
                        System.out.println("Error: Préstamo no existe - " + (idSolo != null ? idSolo : idCompleto));
                    } catch (Exception e) {
                        System.out.println("Error al obtener préstamo " + (idSolo != null ? idSolo : idCompleto) + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
            
            // Guardar lista en request
            request.setAttribute("prestamos", prestamos);
            request.setAttribute("totalPrestamos", prestamos.size());
            request.setAttribute("filtroEstado", filtroEstado);
            
            // Forward a misPrestamos.jsp
            request.getRequestDispatcher("misPrestamos.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en MisPrestamosServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los préstamos: " + e.getMessage());
            request.setAttribute("prestamos", new ArrayList<DtPrestamo>());
            request.getRequestDispatcher("misPrestamos.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}