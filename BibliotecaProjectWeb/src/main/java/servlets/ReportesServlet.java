package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.bibliotecario.BibliotecarioPublicadorService;
import publicadores.bibliotecario.BibliotecarioPublicador;
import publicadores.bibliotecario.StringArray;
import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;

/**
 * Servlet para generar reportes del sistema
 * Consume múltiples Web Services para estadísticas
 */
@WebServlet("/Reportes")
public class ReportesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BibliotecarioPublicador bibliotecarioWS;
    private PrestamoPublicador prestamoWS;
    private LibroPublicador libroWS;

    public ReportesServlet() {
        super();
        bibliotecarioWS = new BibliotecarioPublicadorService().getBibliotecarioPublicadorPort();
        prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
        libroWS = new LibroPublicadorService().getLibroPublicadorPort();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar que el usuario esté autenticado como bibliotecario
        HttpSession session = request.getSession(false);
        if (session == null || !"BIBLIOTECARIO".equals(session.getAttribute("rol"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            
            // Obtener estadísticas de bibliotecarios
            StringArray bibliotecariosArray = bibliotecarioWS.listarBibliotecarios();
            String[] bibliotecarios = bibliotecariosArray.getItem().toArray(new String[0]);
            int totalBibliotecarios = bibliotecarios != null ? bibliotecarios.length : 0;
            
            // Obtener estadísticas de préstamos
            publicadores.prestamo.StringArray prestamosArray = prestamoWS.listarPrestamos();
            String[] prestamos = prestamosArray.getItem().toArray(new String[0]);
            int totalPrestamos = prestamos != null ? prestamos.length : 0;
            
            // Obtener estadísticas de libros
            publicadores.libro.StringArray librosArray = libroWS.listarLibros();
            String[] libros = librosArray.getItem().toArray(new String[0]);
            int totalLibros = libros != null ? libros.length : 0;
            
            
            // Pasar estadísticas a la vista
            request.setAttribute("totalBibliotecarios", totalBibliotecarios);
            request.setAttribute("totalPrestamos", totalPrestamos);
            request.setAttribute("totalLibros", totalLibros);
            request.setAttribute("bibliotecarios", bibliotecarios);
            request.setAttribute("prestamos", prestamos);
            request.setAttribute("libros", libros);
            
            // Calcular estadísticas adicionales
            request.setAttribute("prestamosPorBibliotecario", totalBibliotecarios > 0 ? 
                Math.round((double) totalPrestamos / totalBibliotecarios * 100.0) / 100.0 : 0);
            request.setAttribute("librosPorPrestamo", totalPrestamos > 0 ? 
                Math.round((double) totalLibros / totalPrestamos * 100.0) / 100.0 : 0);
            
            // Redirigir a la página de reportes
            request.getRequestDispatcher("reportes.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // En caso de error, mostrar valores por defecto
            request.setAttribute("totalBibliotecarios", 0);
            request.setAttribute("totalPrestamos", 0);
            request.setAttribute("totalLibros", 0);
            request.setAttribute("error", "Error al generar reportes: " + e.getMessage());
            
            request.getRequestDispatcher("reportes.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirigir a GET
        doGet(request, response);
    }
}
