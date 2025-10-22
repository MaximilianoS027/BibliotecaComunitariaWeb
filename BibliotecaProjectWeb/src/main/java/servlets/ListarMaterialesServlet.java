package servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import publicadores.libro.StringArray;
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;
import publicadores.articuloespecial.ArticuloEspecialPublicador;
import publicadores.articuloespecial.DtArticuloEspecial;

/**
 * Servlet para listar TODOS los materiales del catálogo (libros + artículos especiales)
 * Accesible para LECTOR y BIBLIOTECARIO
 */
@WebServlet("/ListarMateriales")
public class ListarMaterialesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroPublicador libroWS;
    private ArticuloEspecialPublicador articuloEspecialWS;

    public ListarMaterialesServlet() {
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
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            // Guardar la URL de destino para redirigir después del login
            HttpSession newSession = request.getSession();
            newSession.setAttribute("redirectAfterLogin", "ListarMateriales");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String rol = (String) session.getAttribute("rol");
        
        try {
            System.out.println("=== LISTAR TODOS LOS MATERIALES ===");
            
            // ===== OBTENER LIBROS =====
            List<DtLibro> libros = new ArrayList<>();
            try {
                StringArray libroArray = libroWS.listarLibros();
                List<String> idsLibros = libroArray != null ? libroArray.getItem() : new ArrayList<>();
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
                                libros.add(libro);
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
            
            // ===== OBTENER ARTÍCULOS ESPECIALES =====
            List<DtArticuloEspecial> articulos = new ArrayList<>();
            try {
                publicadores.articuloespecial.StringArray articuloArray = articuloEspecialWS.listarArticulosEspeciales();
                List<String> idsArticulos = articuloArray != null ? articuloArray.getItem() : new ArrayList<>();
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
                                articulos.add(articulo);
                            }
                        } catch (Exception e) {
                            System.out.println("Error al obtener artículo especial " + item + ": " + e.getMessage());
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error al listar artículos especiales: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Guardar listas en request
            request.setAttribute("libros", libros);
            request.setAttribute("articulos", articulos);
            request.setAttribute("totalLibros", libros.size());
            request.setAttribute("totalArticulos", articulos.size());
            request.setAttribute("totalMateriales", libros.size() + articulos.size());
            
            // ===== PROCESAMIENTO DE TRAZABILIDAD (solo para BIBLIOTECARIO) =====
            if ("BIBLIOTECARIO".equals(rol)) {
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
                        System.out.println("Filtro fecha desde: " + fechaDesde);
                    } catch (ParseException e) {
                        request.setAttribute("errorTrazabilidad", "Formato de fecha inválido en 'Fecha Desde'");
                    }
                }
                
                if (fechaHastaParam != null && !fechaHastaParam.trim().isEmpty()) {
                    try {
                        fechaHasta = sdf.parse(fechaHastaParam);
                        // Ajustar fechaHasta para incluir todo el día (23:59:59)
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(fechaHasta);
                        cal.set(Calendar.HOUR_OF_DAY, 23);
                        cal.set(Calendar.MINUTE, 59);
                        cal.set(Calendar.SECOND, 59);
                        cal.set(Calendar.MILLISECOND, 999);
                        fechaHasta = cal.getTime();
                        System.out.println("Filtro fecha hasta (ajustada): " + fechaHasta);
                    } catch (ParseException e) {
                        request.setAttribute("errorTrazabilidad", "Formato de fecha inválido en 'Fecha Hasta'");
                    }
                }
                
                // Validar que fecha desde no sea mayor que fecha hasta
                if (fechaDesde != null && fechaHasta != null && fechaDesde.after(fechaHasta)) {
                    request.setAttribute("errorTrazabilidad", "La fecha 'Desde' no puede ser posterior a la fecha 'Hasta'");
                }
                
                // Filtrar por rango de fechas
                List<DtLibro> librosFiltrados = new ArrayList<>();
                List<DtArticuloEspecial> articulosFiltrados = new ArrayList<>();
                
                for (DtLibro libro : libros) {
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
                
                for (DtArticuloEspecial articulo : articulos) {
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
                
                System.out.println("Libros filtrados para trazabilidad: " + librosFiltrados.size());
                System.out.println("Artículos filtrados para trazabilidad: " + articulosFiltrados.size());
                
                // Guardar datos de trazabilidad
                request.setAttribute("librosTrazabilidad", librosFiltrados);
                request.setAttribute("articulosTrazabilidad", articulosFiltrados);
                request.setAttribute("totalLibrosTrazabilidad", librosFiltrados.size());
                request.setAttribute("totalArticulosTrazabilidad", articulosFiltrados.size());
                request.setAttribute("totalDonaciones", librosFiltrados.size() + articulosFiltrados.size());
                request.setAttribute("fechaDesde", fechaDesdeParam);
                request.setAttribute("fechaHasta", fechaHastaParam);
            }
            
            System.out.println("Total de materiales: " + (libros.size() + articulos.size()));
            
            // Forward a catalogoMateriales.jsp
            request.getRequestDispatcher("catalogoMateriales.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en ListarMaterialesServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el catálogo: " + e.getMessage());
            request.setAttribute("libros", new ArrayList<DtLibro>());
            request.setAttribute("articulos", new ArrayList<DtArticuloEspecial>());
            request.getRequestDispatcher("catalogoMateriales.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

