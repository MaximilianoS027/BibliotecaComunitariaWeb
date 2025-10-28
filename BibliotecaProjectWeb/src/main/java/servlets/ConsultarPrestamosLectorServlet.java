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
import publicadores.lector.LectorPublicadorService;
import publicadores.lector.LectorPublicador;
import publicadores.lector.DtLector;
import publicadores.lector.LectorNoExisteException_Exception;

/**
 * Servlet para que bibliotecarios consulten préstamos de un lector específico
 * Solo accesible para BIBLIOTECARIO
 */
@WebServlet("/ConsultarPrestamosLector")
public class ConsultarPrestamosLectorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrestamoPublicador prestamoWS;
    private LectorPublicador lectorWS;

    public ConsultarPrestamosLectorServlet() {
        super();
        prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
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
            System.out.println("=== CONSULTAR PRÉSTAMOS DE LECTOR (BIBLIOTECARIO) ===");
            
            // Obtener parámetros
            String lectorId = request.getParameter("lectorId");
            String filtroEstado = request.getParameter("estado");
            
            if (lectorId == null || lectorId.trim().isEmpty()) {
                request.setAttribute("error", "ID de lector es obligatorio");
                request.getRequestDispatcher("consultarPrestamosLector.jsp").forward(request, response);
                return;
            }
            
            // Obtener información del lector
            DtLector lector = null;
            try {
                lector = lectorWS.obtenerLector(lectorId.trim());
                System.out.println("Lector encontrado: " + lector.getNombre() + " (" + lector.getEmail() + ")");
            } catch (LectorNoExisteException_Exception e) {
                System.out.println("❌ Lector no existe: " + lectorId);
                request.setAttribute("error", "El lector con ID " + lectorId + " no existe");
                request.getRequestDispatcher("consultarPrestamosLector.jsp").forward(request, response);
                return;
            }
            
            // Obtener préstamos del lector
            StringArray prestamosArray = prestamoWS.listarPrestamosPorLector(lectorId.trim());
            List<String> items = prestamosArray != null ? prestamosArray.getItem() : new ArrayList<>();
            
            System.out.println("Total de préstamos encontrados para " + lectorId + ": " + items.size());
            
            List<DtPrestamo> prestamos = new ArrayList<>();
            List<DtPrestamo> prestamosActivos = new ArrayList<>();
            List<DtPrestamo> prestamosPendientes = new ArrayList<>();
            List<DtPrestamo> prestamosEnCurso = new ArrayList<>();
            List<DtPrestamo> prestamosDevueltos = new ArrayList<>();
            
            for (String item : items) {
                try {
                    // Extraer ID del formato "P1 - Lector Info - Material Info - Estado"
                    String id = item;
                    if (item.contains(" - ")) {
                        String[] parts = item.split(" - ");
                        id = parts[0].trim();
                    }
                    
                    System.out.println("Obteniendo préstamo: " + id);
                    DtPrestamo prestamo = prestamoWS.obtenerPrestamo(id);
                    if (prestamo != null) {
                        prestamos.add(prestamo);
                        
                        // Clasificar por estado
                        String estado = prestamo.getEstado();
                        if ("PENDIENTE".equals(estado)) {
                            prestamosPendientes.add(prestamo);
                        } else if ("EN_CURSO".equals(estado)) {
                            prestamosEnCurso.add(prestamo);
                            prestamosActivos.add(prestamo); // Los EN_CURSO son activos
                        } else if ("DEVUELTO".equals(estado)) {
                            prestamosDevueltos.add(prestamo);
                        }
                        
                        System.out.println("✅ Préstamo obtenido: " + prestamo.getId() + " - " + prestamo.getEstado());
                    }
                } catch (PrestamoNoExisteException_Exception e) {
                    System.out.println("❌ Préstamo no existe: " + item);
                } catch (Exception e) {
                    System.out.println("❌ Error al obtener préstamo " + item + ": " + e.getMessage());
                }
            }
            
            // Aplicar filtro de estado si se especifica
            List<DtPrestamo> prestamosFiltrados = prestamos;
            if (filtroEstado != null && !filtroEstado.trim().isEmpty()) {
                prestamosFiltrados = new ArrayList<>();
                for (DtPrestamo p : prestamos) {
                    if (filtroEstado.equals(p.getEstado())) {
                        prestamosFiltrados.add(p);
                    }
                }
            }
            
            // Estadísticas
            int totalPrestamos = prestamos.size();
            int totalActivos = prestamosActivos.size();
            int totalPendientes = prestamosPendientes.size();
            int totalEnCurso = prestamosEnCurso.size();
            int totalDevueltos = prestamosDevueltos.size();
            
            System.out.println("Estadísticas del lector:");
            System.out.println("- Total préstamos: " + totalPrestamos);
            System.out.println("- Activos: " + totalActivos);
            System.out.println("- Pendientes: " + totalPendientes);
            System.out.println("- En curso: " + totalEnCurso);
            System.out.println("- Devueltos: " + totalDevueltos);
            
            // Guardar datos en request
            request.setAttribute("lector", lector);
            request.setAttribute("prestamos", prestamosFiltrados);
            request.setAttribute("prestamosActivos", prestamosActivos);
            request.setAttribute("totalPrestamos", totalPrestamos);
            request.setAttribute("totalActivos", totalActivos);
            request.setAttribute("totalPendientes", totalPendientes);
            request.setAttribute("totalEnCurso", totalEnCurso);
            request.setAttribute("totalDevueltos", totalDevueltos);
            request.setAttribute("filtroEstado", filtroEstado);
            
            // Forward a la JSP
            request.getRequestDispatcher("consultarPrestamosLector.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ ERROR en ConsultarPrestamosLectorServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al consultar préstamos del lector: " + e.getMessage());
            request.getRequestDispatcher("consultarPrestamosLector.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
