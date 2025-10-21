package servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import javax.xml.datatype.XMLGregorianCalendar;
import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;
import publicadores.libro.DtLibro;
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;
import publicadores.articuloespecial.ArticuloEspecialPublicador;
import publicadores.articuloespecial.DtArticuloEspecial;

/**
 * Servlet para consultar la trazabilidad del inventario (donaciones) por rango de fechas
 * Solo accesible para usuarios con rol BIBLIOTECARIO
 */
@WebServlet("/TrazabilidadInventario")
public class TrazabilidadInventarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroPublicador libroWS;
    private ArticuloEspecialPublicador articuloEspecialWS;

    public TrazabilidadInventarioServlet() {
        super();
        libroWS = new LibroPublicadorService().getLibroPublicadorPort();
        articuloEspecialWS = new ArticuloEspecialPublicadorService().getArticuloEspecialPublicadorPort();
    }
    
    /**
     * Convierte XMLGregorianCalendar a java.util.Date
     */
    private Date convertirXMLGregorianCalendarADate(XMLGregorianCalendar xmlCalendar) {
        if (xmlCalendar == null) {
            return null;
        }
        return xmlCalendar.toGregorianCalendar().getTime();
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
            System.out.println("=== TRAZABILIDAD INVENTARIO ===");
            
            // Obtener parámetros de filtro de fechas
            String fechaDesdeParam = request.getParameter("fechaDesde");
            String fechaHastaParam = request.getParameter("fechaHasta");
            
            Date fechaDesde = null;
            Date fechaHasta = null;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            
            // Parsear fechas si existen
            if (fechaDesdeParam != null && !fechaDesdeParam.trim().isEmpty()) {
                try {
                    fechaDesde = sdf.parse(fechaDesdeParam);
                    System.out.println("Fecha desde: " + fechaDesde);
                } catch (ParseException e) {
                    request.setAttribute("error", "Formato de fecha inválido en 'Fecha Desde'");
                }
            }
            
            if (fechaHastaParam != null && !fechaHastaParam.trim().isEmpty()) {
                try {
                    fechaHasta = sdf.parse(fechaHastaParam);
                    System.out.println("Fecha hasta: " + fechaHasta);
                } catch (ParseException e) {
                    request.setAttribute("error", "Formato de fecha inválido en 'Fecha Hasta'");
                }
            }
            
            // Validar que fecha desde no sea mayor que fecha hasta
            if (fechaDesde != null && fechaHasta != null && fechaDesde.after(fechaHasta)) {
                request.setAttribute("error", "La fecha 'Desde' no puede ser posterior a la fecha 'Hasta'");
            }
            
            // Obtener todos los libros
            List<DtLibro> todosLosLibros = new ArrayList<>();
            try {
                publicadores.libro.StringArray librosArray = libroWS.listarLibros();
                List<String> idsLibros = librosArray != null ? librosArray.getItem() : new ArrayList<>();
                System.out.println("Total de libros encontrados: " + (idsLibros != null ? idsLibros.size() : 0));
                
                if (idsLibros != null && !idsLibros.isEmpty()) {
                    for (String item : idsLibros) {
                        try {
                            String id = item;
                            if (item.contains(" | ")) {
                                String[] parts = item.split(" \\| ");
                                id = parts[0].trim();
                            }
                            
                            DtLibro libro = libroWS.obtenerLibro(id);
                            if (libro != null) {
                                todosLosLibros.add(libro);
                            }
                        } catch (Exception e) {
                            System.out.println("Error al obtener libro " + item + ": " + e.getMessage());
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error al listar libros: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Obtener todos los artículos especiales
            List<DtArticuloEspecial> todosLosArticulos = new ArrayList<>();
            try {
                publicadores.articuloespecial.StringArray articulosArray = articuloEspecialWS.listarArticulosEspeciales();
                List<String> idsArticulos = articulosArray != null ? articulosArray.getItem() : new ArrayList<>();
                System.out.println("Total de artículos especiales encontrados: " + (idsArticulos != null ? idsArticulos.size() : 0));
                
                if (idsArticulos != null && !idsArticulos.isEmpty()) {
                    for (String item : idsArticulos) {
                        try {
                            String id = item;
                            if (item.contains(" | ")) {
                                String[] parts = item.split(" \\| ");
                                id = parts[0].trim();
                            }
                            
                            DtArticuloEspecial articulo = articuloEspecialWS.obtenerArticuloEspecial(id);
                            if (articulo != null) {
                                todosLosArticulos.add(articulo);
                            }
                        } catch (Exception e) {
                            System.out.println("Error al obtener artículo " + item + ": " + e.getMessage());
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error al listar artículos especiales: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Filtrar por rango de fechas
            List<DtLibro> librosFiltrados = new ArrayList<>();
            List<DtArticuloEspecial> articulosFiltrados = new ArrayList<>();
            
            for (DtLibro libro : todosLosLibros) {
                Date fechaRegistro = convertirXMLGregorianCalendarADate(libro.getFechaRegistro());
                if (fechaRegistro != null) {
                    boolean cumpleFiltro = true;
                    
                    if (fechaDesde != null && fechaRegistro.before(fechaDesde)) {
                        cumpleFiltro = false;
                    }
                    
                    if (fechaHasta != null && fechaRegistro.after(fechaHasta)) {
                        cumpleFiltro = false;
                    }
                    
                    if (cumpleFiltro) {
                        librosFiltrados.add(libro);
                    }
                }
            }
            
            for (DtArticuloEspecial articulo : todosLosArticulos) {
                Date fechaRegistro = convertirXMLGregorianCalendarADate(articulo.getFechaRegistro());
                if (fechaRegistro != null) {
                    boolean cumpleFiltro = true;
                    
                    if (fechaDesde != null && fechaRegistro.before(fechaDesde)) {
                        cumpleFiltro = false;
                    }
                    
                    if (fechaHasta != null && fechaRegistro.after(fechaHasta)) {
                        cumpleFiltro = false;
                    }
                    
                    if (cumpleFiltro) {
                        articulosFiltrados.add(articulo);
                    }
                }
            }
            
            System.out.println("Libros filtrados: " + librosFiltrados.size());
            System.out.println("Artículos filtrados: " + articulosFiltrados.size());
            
            // Guardar en request
            request.setAttribute("libros", librosFiltrados);
            request.setAttribute("articulos", articulosFiltrados);
            request.setAttribute("totalLibros", librosFiltrados.size());
            request.setAttribute("totalArticulos", articulosFiltrados.size());
            request.setAttribute("totalDonaciones", librosFiltrados.size() + articulosFiltrados.size());
            request.setAttribute("fechaDesde", fechaDesdeParam);
            request.setAttribute("fechaHasta", fechaHastaParam);
            
            // Forward a trazabilidadInventario.jsp
            request.getRequestDispatcher("trazabilidadInventario.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en TrazabilidadInventarioServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al consultar la trazabilidad del inventario: " + e.getMessage());
            request.setAttribute("libros", new ArrayList<DtLibro>());
            request.setAttribute("articulos", new ArrayList<DtArticuloEspecial>());
            request.getRequestDispatcher("trazabilidadInventario.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

