package servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import publicadores.bibliotecario.BibliotecarioPublicadorService;
import publicadores.bibliotecario.BibliotecarioPublicador;
import publicadores.bibliotecario.DtBibliotecario;

/**
 * Servlet para gestión completa de préstamos (solo BIBLIOTECARIO)
 * Incluye: listar todos, historial por bibliotecario, reporte por zona, materiales más prestados
 */
@WebServlet("/ListarPrestamos")
public class ListarPrestamosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrestamoPublicador prestamoWS;
    private LectorPublicador lectorWS;
    private BibliotecarioPublicador bibliotecarioWS;

    public ListarPrestamosServlet() {
        super();
        prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
        lectorWS = new LectorPublicadorService().getLectorPublicadorPort();
        bibliotecarioWS = new BibliotecarioPublicadorService().getBibliotecarioPublicadorPort();
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
        if (!"BIBLIOTECARIO".equals(rol)) {
            response.sendRedirect("home.jsp?error=permisos");
            return;
        }
        
        try {
            System.out.println("=== GESTIÓN DE PRÉSTAMOS (BIBLIOTECARIO) ===");
            
            // Obtener parámetros de filtros
            String filtroEstado = request.getParameter("estado");
            String filtroBibliotecario = request.getParameter("bibliotecarioId");
            String filtroZona = request.getParameter("zona");
            String vistaActiva = request.getParameter("vista"); // "todos", "historial", "zona", "materiales"
            
            if (vistaActiva == null) vistaActiva = "todos";
            
            // ===== OBTENER TODOS LOS PRÉSTAMOS =====
            List<DtPrestamo> todosPrestamos = obtenerTodosPrestamos();
            
            // ===== FILTRAR SEGÚN LA VISTA ACTIVA =====
            List<DtPrestamo> prestamosFiltrados = new ArrayList<>();
            
            switch (vistaActiva) {
                case "historial":
                    // Historial de préstamos gestionados por un bibliotecario
                    if (filtroBibliotecario != null && !filtroBibliotecario.trim().isEmpty()) {
                        for (DtPrestamo p : todosPrestamos) {
                            if (p.getBibliotecarioId() != null && 
                                p.getBibliotecarioId().equals(filtroBibliotecario)) {
                                prestamosFiltrados.add(p);
                            }
                        }
                        System.out.println("Préstamos del bibliotecario " + filtroBibliotecario + ": " + prestamosFiltrados.size());
                    } else {
                        prestamosFiltrados = todosPrestamos;
                    }
                    break;
                    
                case "zona":
                    // Reporte de préstamos por zona
                    if (filtroZona != null && !filtroZona.trim().isEmpty()) {
                        System.out.println("Filtrando por zona: " + filtroZona);
                        for (DtPrestamo p : todosPrestamos) {
                            try {
                                // Obtener lector para saber su zona
                                DtLector lector = lectorWS.obtenerLector(p.getLectorId());
                                if (lector != null && lector.getZona() != null) {
                                    String zonaLector = lector.getZona().toString();
                                    System.out.println("Lector " + lector.getNombre() + " zona: '" + zonaLector + "' vs filtro: '" + filtroZona + "'");
                                    
                                    // Mapeo de zonas para comparación
                                    boolean coincide = false;
                                    
                                    // Comparación directa
                                    if (zonaLector.equals(filtroZona)) {
                                        coincide = true;
                                    }
                                    // Comparación con mapeo de nombres de enum a descripciones
                                    else if (filtroZona.equals("Biblioteca Central") && zonaLector.equals("BIBLIOTECA_CENTRAL")) {
                                        coincide = true;
                                    } else if (filtroZona.equals("Sucursal Este") && zonaLector.equals("SUCURSAL_ESTE")) {
                                        coincide = true;
                                    } else if (filtroZona.equals("Sucursal Oeste") && zonaLector.equals("SUCURSAL_OESTE")) {
                                        coincide = true;
                                    } else if (filtroZona.equals("Biblioteca Infantil") && zonaLector.equals("BIBLIOTECA_INFANTIL")) {
                                        coincide = true;
                                    } else if (filtroZona.equals("Archivo General") && zonaLector.equals("ARCHIVO_GENERAL")) {
                                        coincide = true;
                                    }
                                    
                                    if (coincide) {
                                        prestamosFiltrados.add(p);
                                        System.out.println("✅ Préstamo " + p.getId() + " agregado para zona " + filtroZona);
                                    } else {
                                        System.out.println("❌ No coincide: '" + zonaLector + "' != '" + filtroZona + "'");
                                    }
                                }
                            } catch (Exception e) {
                                System.out.println("Error al obtener zona del lector: " + e.getMessage());
                            }
                        }
                        System.out.println("Préstamos de la zona " + filtroZona + ": " + prestamosFiltrados.size());
                    } else {
                        prestamosFiltrados = todosPrestamos;
                    }
                    break;
                    
                case "materiales":
                    // Identificar materiales con muchos préstamos activos
                    System.out.println("=== VISTA MATERIALES MÁS PRESTADOS ===");
                    System.out.println("Total de préstamos en el sistema: " + todosPrestamos.size());
                    
                    prestamosFiltrados = new ArrayList<>();
                    for (DtPrestamo p : todosPrestamos) {
                        // Préstamos activos: cualquier estado excepto DEVUELTO
                        String estado = p.getEstado();
                        System.out.println("Evaluando préstamo " + p.getId() + " - Estado: '" + estado + "'");
                        
                        if (!"DEVUELTO".equalsIgnoreCase(estado) && !"Devuelto".equals(estado)) {
                            prestamosFiltrados.add(p);
                            System.out.println("  ✓ Préstamo " + p.getId() + " agregado (estado: " + estado + ")");
                        } else {
                            System.out.println("  ✗ Préstamo " + p.getId() + " omitido (devuelto)");
                        }
                    }
                    
                    System.out.println("DEBUG: Total de préstamos activos encontrados: " + prestamosFiltrados.size());
                    
                    // Contar préstamos por material
                    Map<String, Integer> prestamosporMaterial = new HashMap<>();
                    for (DtPrestamo p : prestamosFiltrados) {
                        String materialId = p.getMaterialId();
                        prestamosporMaterial.put(materialId, 
                            prestamosporMaterial.getOrDefault(materialId, 0) + 1);
                        System.out.println("  Material " + materialId + " ahora tiene " + 
                            prestamosporMaterial.get(materialId) + " préstamos");
                    }
                    
                    System.out.println("DEBUG: prestamosporMaterial.size() = " + prestamosporMaterial.size());
                    for (Map.Entry<String, Integer> entry : prestamosporMaterial.entrySet()) {
                        System.out.println("  - Material: " + entry.getKey() + " -> " + entry.getValue() + " préstamos");
                    }
                    
                    // Filtrar solo materiales con 2 o más préstamos
                    Map<String, Integer> materialesConMultiplesPrestamos = new HashMap<>();
                    for (Map.Entry<String, Integer> entry : prestamosporMaterial.entrySet()) {
                        if (entry.getValue() >= 2) {
                            materialesConMultiplesPrestamos.put(entry.getKey(), entry.getValue());
                            System.out.println("  ✓ Material " + entry.getKey() + " tiene " + entry.getValue() + " préstamos (incluido)");
                        } else {
                            System.out.println("  ✗ Material " + entry.getKey() + " tiene solo " + entry.getValue() + " préstamo (excluido)");
                        }
                    }
                    
                    System.out.println("DEBUG: Materiales con 2+ préstamos: " + materialesConMultiplesPrestamos.size());
                    
                    request.setAttribute("prestamosPorMaterial", prestamosporMaterial);
                    request.setAttribute("materialesMultiples", materialesConMultiplesPrestamos);
                    System.out.println("Préstamos activos por material calculados");
                    break;
                    
                default: // "todos"
                    // Filtrar por estado si se especifica
                    if (filtroEstado != null && !filtroEstado.trim().isEmpty()) {
                        for (DtPrestamo p : todosPrestamos) {
                            if (p.getEstado() != null && p.getEstado().equals(filtroEstado)) {
                                prestamosFiltrados.add(p);
                            }
                        }
                        System.out.println("Préstamos con estado " + filtroEstado + ": " + prestamosFiltrados.size());
                    } else {
                        prestamosFiltrados = todosPrestamos;
                    }
                    break;
            }
            
            // ===== ESTADÍSTICAS GENERALES =====
            int totalPrestamos = todosPrestamos.size();
            int prestamosPendientes = 0;
            int prestamosEnCurso = 0;
            int prestamosDevueltos = 0;
            
            for (DtPrestamo p : todosPrestamos) {
                if ("PENDIENTE".equals(p.getEstado())) {
                    prestamosPendientes++;
                } else if ("EN_CURSO".equals(p.getEstado())) {
                    prestamosEnCurso++;
                } else if ("DEVUELTO".equals(p.getEstado())) {
                    prestamosDevueltos++;
                }
            }
            
            // ===== OBTENER LISTA DE BIBLIOTECARIOS PARA EL FILTRO =====
            List<DtBibliotecario> bibliotecarios = obtenerBibliotecarios();
            System.out.println("Bibliotecarios obtenidos para dropdown: " + bibliotecarios.size());
            for (DtBibliotecario bib : bibliotecarios) {
                System.out.println("- " + bib.getNumeroEmpleado() + " - " + bib.getNombre() + " (" + bib.getEmail() + ")");
            }
            
            // ===== GUARDAR DATOS EN REQUEST =====
            request.setAttribute("prestamos", prestamosFiltrados);
            request.setAttribute("todosPrestamos", todosPrestamos);
            request.setAttribute("totalPrestamos", totalPrestamos);
            request.setAttribute("prestamosPendientes", prestamosPendientes);
            request.setAttribute("prestamosEnCurso", prestamosEnCurso);
            request.setAttribute("prestamosDevueltos", prestamosDevueltos);
            request.setAttribute("bibliotecarios", bibliotecarios);
            
            // Guardar filtros aplicados
            request.setAttribute("filtroEstado", filtroEstado);
            request.setAttribute("filtroBibliotecario", filtroBibliotecario);
            request.setAttribute("filtroZona", filtroZona);
            request.setAttribute("vistaActiva", vistaActiva);
            
            System.out.println("Total préstamos: " + totalPrestamos);
            System.out.println("Préstamos filtrados: " + prestamosFiltrados.size());
            
            // Forward a gestionPrestamos.jsp
            request.getRequestDispatcher("gestionPrestamos.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en ListarPrestamosServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los préstamos: " + e.getMessage());
            request.setAttribute("prestamos", new ArrayList<DtPrestamo>());
            request.getRequestDispatcher("gestionPrestamos.jsp").forward(request, response);
        }
    }

    /**
     * Obtiene todos los préstamos del sistema
     */
    private List<DtPrestamo> obtenerTodosPrestamos() {
        List<DtPrestamo> prestamos = new ArrayList<>();
        try {
            // El web service devuelve StringArray
            StringArray prestamosArray = prestamoWS.listarPrestamos();
            List<String> items = prestamosArray != null ? prestamosArray.getItem() : new ArrayList<>();
            
            System.out.println("Total de préstamos encontrados: " + items.size());
            
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
                        System.out.println("✅ Préstamo obtenido: " + prestamo.getId() + " - " + prestamo.getEstado());
                    }
                } catch (PrestamoNoExisteException_Exception e) {
                    System.out.println("❌ Préstamo no existe: " + item);
                } catch (Exception e) {
                    System.out.println("❌ Error al obtener préstamo " + item + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Error al listar préstamos: " + e.getMessage());
            e.printStackTrace();
        }
        return prestamos;
    }
    
    /**
     * Obtiene todos los bibliotecarios del sistema
     */
    private List<DtBibliotecario> obtenerBibliotecarios() {
        List<DtBibliotecario> bibliotecarios = new ArrayList<>();
        try {
            // El web service devuelve StringArray
            publicadores.bibliotecario.StringArray bibArray = bibliotecarioWS.listarBibliotecarios();
            List<String> items = bibArray != null ? bibArray.getItem() : new ArrayList<>();
            
            System.out.println("Total de bibliotecarios encontrados: " + items.size());
            
            for (String item : items) {
                try {
                    // Extraer ID del formato "B1 - Nombre (email)"
                    String id = item;
                    if (item.contains(" - ")) {
                        String[] parts = item.split(" - ");
                        id = parts[0].trim();
                    }
                    
                    System.out.println("Obteniendo bibliotecario: " + id);
                    DtBibliotecario bib = bibliotecarioWS.obtenerBibliotecario(id);
                    if (bib != null) {
                        bibliotecarios.add(bib);
                        System.out.println("✅ Bibliotecario obtenido: " + bib.getEmail() + " - " + bib.getNombre());
                    }
                } catch (Exception e) {
                    System.out.println("❌ Error al obtener bibliotecario " + item + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Error al listar bibliotecarios: " + e.getMessage());
            e.printStackTrace();
        }
        return bibliotecarios;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

