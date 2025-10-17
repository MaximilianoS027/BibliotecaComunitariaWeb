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

/**
 * Servlet para listar todos los bibliotecarios del sistema
 * Consume Web Service de bibliotecarios
 */
@WebServlet("/ListarBibliotecarios")
public class ListarBibliotecariosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BibliotecarioPublicador bibliotecarioWS;

    public ListarBibliotecariosServlet() {
        super();
        bibliotecarioWS = new BibliotecarioPublicadorService().getBibliotecarioPublicadorPort();
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
            
            // Obtener lista de bibliotecarios usando Web Service
            StringArray bibliotecariosArray = bibliotecarioWS.listarBibliotecarios();
            String[] bibliotecarios = bibliotecariosArray.getItem().toArray(new String[0]);
            
            
            // Pasar la lista a la vista
            request.setAttribute("bibliotecarios", bibliotecarios);
            request.setAttribute("totalBibliotecarios", bibliotecarios != null ? bibliotecarios.length : 0);
            
            // Redirigir a la página de gestión
            request.getRequestDispatcher("gestionBibliotecarios.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // En caso de error, mostrar página vacía
            request.setAttribute("bibliotecarios", new String[0]);
            request.setAttribute("totalBibliotecarios", 0);
            request.setAttribute("error", "Error al cargar bibliotecarios: " + e.getMessage());
            
            request.getRequestDispatcher("gestionBibliotecarios.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirigir a GET
        doGet(request, response);
    }
}
