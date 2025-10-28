package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import publicadores.lector.LectorPublicadorService;
import publicadores.lector.LectorPublicador;
import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;
import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.articuloespecial.ArticuloEspecialPublicador;
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;

/**
 * Servlet que devuelve estadísticas en formato JSON
 */
@WebServlet("/EstadisticasAPI")
public class EstadisticasAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            LectorPublicador lectorWS = new LectorPublicadorService().getLectorPublicadorPort();
            LibroPublicador libroWS = new LibroPublicadorService().getLibroPublicadorPort();
            ArticuloEspecialPublicador articuloWS = new ArticuloEspecialPublicadorService().getArticuloEspecialPublicadorPort();
            PrestamoPublicador prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
            
            // Total Lectores
            publicadores.lector.StringArray lectoresArray = lectorWS.listarLectores();
            int totalLectores = lectoresArray != null && lectoresArray.getItem() != null ? lectoresArray.getItem().size() : 0;
            
            // Total Libros + Artículos
            publicadores.libro.StringArray librosArray = libroWS.listarLibros();
            int totalLibros = librosArray != null && librosArray.getItem() != null ? librosArray.getItem().size() : 0;
            
            publicadores.articuloespecial.StringArray articulosArray = articuloWS.listarArticulosEspeciales();
            int totalArticulos = articulosArray != null && articulosArray.getItem() != null ? articulosArray.getItem().size() : 0;
            
            int materialesDisponibles = totalLibros + totalArticulos;
            
            // Total de préstamos
            publicadores.prestamo.StringArray prestamosArray = prestamoWS.listarPrestamos();
            int prestamosEsteMes = prestamosArray != null && prestamosArray.getItem() != null ? prestamosArray.getItem().size() : 0;
            
            String json = String.format(
                "{\"totalLectores\": %d, \"materialesDisponibles\": %d, \"prestamosEsteMes\": %d}",
                totalLectores,
                materialesDisponibles,
                prestamosEsteMes
            );
            
            out.print(json);
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"totalLectores\": 0, \"materialesDisponibles\": 0, \"prestamosEsteMes\": 0}");
            out.flush();
        }
    }
}

