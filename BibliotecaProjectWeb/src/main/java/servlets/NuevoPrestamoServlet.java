package servlets;

import java.io.IOException;
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
import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.prestamo.DatosInvalidosException_Exception;
import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;
import publicadores.libro.DtLibro;
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;
import publicadores.articuloespecial.ArticuloEspecialPublicador;
import publicadores.articuloespecial.DtArticuloEspecial;

/**
 * Servlet para solicitar nuevos préstamos
 * Solo accesible para usuarios con rol LECTOR
 */
@WebServlet("/NuevoPrestamo")
public class NuevoPrestamoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrestamoPublicador prestamoWS;
    private LibroPublicador libroWS;
    private ArticuloEspecialPublicador articuloWS;

    public NuevoPrestamoServlet() {
        super();
        prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
        libroWS = new LibroPublicadorService().getLibroPublicadorPort();
        articuloWS = new ArticuloEspecialPublicadorService().getArticuloEspecialPublicadorPort();
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
        
        try {
            System.out.println("=== NUEVO PRÉSTAMO - CARGAR MATERIALES ===");
            
            // Obtener parámetros de preselección
            String materialIdPreseleccionado = request.getParameter("materialId");
            String materialTipoPreseleccionado = request.getParameter("materialTipo");
            
            // Obtener materiales disponibles
            List<DtLibro> libros = new ArrayList<>();
            List<DtArticuloEspecial> articulos = new ArrayList<>();
            
            // Obtener libros
            try {
                System.out.println("=== CARGANDO LIBROS ===");
                publicadores.libro.StringArray librosArray = libroWS.listarLibros();
                System.out.println("StringArray de libros: " + librosArray);
                
                if (librosArray != null && librosArray.getItem() != null) {
                    System.out.println("Items de libros encontrados: " + librosArray.getItem().size());
                    for (String item : librosArray.getItem()) {
                        System.out.println("Procesando item: " + item);
                        try {
                            // El backend retorna: "ID | Título | Páginas | Fecha"
                            // Extraer solo el ID (primera parte)
                            String id = item;
                            if (item.contains(" | ")) {
                                String[] parts = item.split(" \\| ");
                                id = parts[0].trim();
                            }
                            
                            System.out.println("ID extraído: " + id);
                            DtLibro libro = libroWS.obtenerLibro(id);
                            if (libro != null) {
                                libros.add(libro);
                                System.out.println("Libro agregado: " + libro.getTitulo());
                            } else {
                                System.out.println("Libro es null para ID: " + id);
                            }
                        } catch (Exception e) {
                            System.out.println("Error al obtener libro " + item + ": " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                } else {
                    System.out.println("No hay libros disponibles o StringArray es null");
                }
                System.out.println("Total libros cargados: " + libros.size());
            } catch (Exception e) {
                System.out.println("Error al listar libros: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Obtener artículos especiales
            try {
                System.out.println("=== CARGANDO ARTÍCULOS ESPECIALES ===");
                publicadores.articuloespecial.StringArray articulosArray = articuloWS.listarArticulosEspeciales();
                System.out.println("StringArray de artículos: " + articulosArray);
                
                if (articulosArray != null && articulosArray.getItem() != null) {
                    System.out.println("Items de artículos encontrados: " + articulosArray.getItem().size());
                    for (String item : articulosArray.getItem()) {
                        System.out.println("Procesando item: " + item);
                        try {
                            // El backend retorna: "ID | Descripción | Peso | Dimensiones | Fecha"
                            // Extraer solo el ID (primera parte)
                            String id = item;
                            if (item.contains(" | ")) {
                                String[] parts = item.split(" \\| ");
                                id = parts[0].trim();
                            }
                            
                            System.out.println("ID extraído: " + id);
                            DtArticuloEspecial articulo = articuloWS.obtenerArticuloEspecial(id);
                            if (articulo != null) {
                                articulos.add(articulo);
                                System.out.println("Artículo agregado: " + articulo.getDescripcion());
                            } else {
                                System.out.println("Artículo es null para ID: " + id);
                            }
                        } catch (Exception e) {
                            System.out.println("Error al obtener artículo " + item + ": " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                } else {
                    System.out.println("No hay artículos especiales disponibles o StringArray es null");
                }
                System.out.println("Total artículos cargados: " + articulos.size());
            } catch (Exception e) {
                System.out.println("Error al listar artículos: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Guardar materiales en request
            request.setAttribute("libros", libros);
            request.setAttribute("articulos", articulos);
            request.setAttribute("materialIdPreseleccionado", materialIdPreseleccionado);
            request.setAttribute("materialTipoPreseleccionado", materialTipoPreseleccionado);
            
            // Forward a nuevoPrestamo.jsp
            request.getRequestDispatcher("nuevoPrestamo.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en NuevoPrestamoServlet (GET): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los materiales: " + e.getMessage());
            request.getRequestDispatcher("nuevoPrestamo.jsp").forward(request, response);
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
        if (!"LECTOR".equals(rol)) {
            response.sendRedirect("home.jsp?error=permisos");
            return;
        }
        
        // Obtener parámetros del formulario
        String lectorId = (String) session.getAttribute("usuarioId");
        String materialId = request.getParameter("materialId");
        String materialTipo = request.getParameter("materialTipo");
        // Obtener un bibliotecario válido del sistema dinámicamente de forma aleatoria
        String bibliotecarioId = null;
        try {
            publicadores.bibliotecario.BibliotecarioPublicadorService bibliotecarioService = 
                new publicadores.bibliotecario.BibliotecarioPublicadorService();
            publicadores.bibliotecario.BibliotecarioPublicador bibliotecarioWS = 
                bibliotecarioService.getBibliotecarioPublicadorPort();
            
            publicadores.bibliotecario.StringArray bibliotecariosArray = bibliotecarioWS.listarBibliotecarios();
            if (bibliotecariosArray != null && bibliotecariosArray.getItem() != null && !bibliotecariosArray.getItem().isEmpty()) {
                // Seleccionar bibliotecario de forma aleatoria
                java.util.List<String> bibliotecarios = bibliotecariosArray.getItem();
                java.util.Random random = new java.util.Random();
                int indiceAleatorio = random.nextInt(bibliotecarios.size());
                
                String item = bibliotecarios.get(indiceAleatorio);
                String extraido = item;
                if (item.contains(" | ")) {
                    // Formato: B1 | nombre (email)
                    extraido = item.split(" \\| ")[0];
                } else if (item.contains(" - ")) {
                    // Formato: B1 - nombre (email)
                    extraido = item.split(" - ")[0];
                }
                bibliotecarioId = extraido.trim();
                System.out.println("Bibliotecario seleccionado aleatoriamente (índice " + indiceAleatorio + "): " + bibliotecarioId + " | Original: " + item);
            } else {
                throw new Exception("No hay bibliotecarios disponibles en el sistema");
            }
        } catch (Exception e) {
            System.out.println("Error al obtener bibliotecario: " + e.getMessage());
            request.setAttribute("error", "Error del sistema: No hay bibliotecarios disponibles");
            doGet(request, response);
            return;
        }
        
        try {
            // Validar datos básicos
            if (lectorId == null || lectorId.trim().isEmpty()) {
                request.setAttribute("error", "Error de sesión: Usuario no identificado");
                doGet(request, response);
                return;
            }
            
            if (materialId == null || materialId.trim().isEmpty()) {
                request.setAttribute("error", "Debe seleccionar un material");
                doGet(request, response);
                return;
            }
            
            if (materialTipo == null || materialTipo.trim().isEmpty()) {
                request.setAttribute("error", "Debe especificar el tipo de material");
                doGet(request, response);
                return;
            }
            
            // Validar que el lector existe en el sistema y está activo
            try {
                publicadores.lector.LectorPublicadorService lectorService = 
                    new publicadores.lector.LectorPublicadorService();
                publicadores.lector.LectorPublicador lectorWS = 
                    lectorService.getLectorPublicadorPort();
                
                // Obtener el lector para validar que existe y está activo
                publicadores.lector.DtLector lector = lectorWS.obtenerLector(lectorId);
                System.out.println("Lector validado: " + lectorId);
                
                // Verificar que el lector esté activo (no suspendido)
                if (lector.getEstado() != null && "SUSPENDIDO".equals(lector.getEstado().toString().toUpperCase())) {
                    System.out.println("Error: Lector suspendido - " + lectorId);
                    request.setAttribute("error", "No puede solicitar préstamos porque su cuenta está suspendida. Contacte al bibliotecario para reactivar su cuenta.");
                    doGet(request, response);
                    return;
                }
                
                System.out.println("Lector activo validado: " + lectorId);
            } catch (Exception e) {
                System.out.println("Error: Lector no existe - " + lectorId);
                request.setAttribute("error", "Error: El usuario no existe en el sistema");
                doGet(request, response);
                return;
            }
            
            // Generar fecha de solicitud actual en formato esperado por el backend
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String fechaSolicitud = sdf.format(new Date());
            
            // Llamar al Web Service
            System.out.println("=== REGISTRAR PRÉSTAMO ===");
            System.out.println("Lector ID: " + lectorId);
            System.out.println("Bibliotecario ID: " + bibliotecarioId);
            System.out.println("Material ID: " + materialId);
            System.out.println("Material Tipo: " + materialTipo);
            System.out.println("Estado: PENDIENTE");
            System.out.println("Fecha Solicitud: " + fechaSolicitud);
            
            // Validar que todos los parámetros estén presentes
            if (bibliotecarioId == null || bibliotecarioId.trim().isEmpty()) {
                throw new Exception("No se pudo obtener un bibliotecario válido");
            }
            
            System.out.println("Intentando registrar préstamo con parámetros:");
            System.out.println("- Lector: " + lectorId);
            System.out.println("- Bibliotecario: " + bibliotecarioId);
            System.out.println("- Material: " + materialId);
            System.out.println("- Estado: PENDIENTE");
            System.out.println("- Fecha: " + fechaSolicitud);
            
            prestamoWS.registrarPrestamo(lectorId, bibliotecarioId, materialId, fechaSolicitud, "PENDIENTE");
            System.out.println("Préstamo registrado exitosamente");
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("MisPrestamos?success=solicitud_enviada");
            
        } catch (DatosInvalidosException_Exception e) {
            System.out.println("Error: Datos inválidos - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Los datos proporcionados no son válidos: " + e.getMessage());
            doGet(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en NuevoPrestamoServlet (POST): " + e.getMessage());
            System.out.println("Tipo de excepción: " + e.getClass().getName());
            e.printStackTrace();
            
            // Obtener más detalles del error
            String errorMessage = "Error al solicitar el préstamo: " + e.getMessage();
            if (e.getCause() != null) {
                errorMessage += " (Causa: " + e.getCause().getMessage() + ")";
            }
            
            request.setAttribute("error", errorMessage);
            doGet(request, response);
        }
    }
}
