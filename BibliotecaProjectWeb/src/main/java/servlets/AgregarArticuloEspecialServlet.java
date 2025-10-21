package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;
import publicadores.articuloespecial.ArticuloEspecialPublicador;
import publicadores.articuloespecial.ArticuloEspecialRepetidoException_Exception;
import publicadores.articuloespecial.DatosInvalidosException_Exception;

/**
 * Servlet para agregar nuevos artículos especiales al catálogo
 * Solo accesible para usuarios con rol BIBLIOTECARIO
 */
@WebServlet("/AgregarArticuloEspecial")
public class AgregarArticuloEspecialServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ArticuloEspecialPublicador articuloEspecialWS;

    public AgregarArticuloEspecialServlet() {
        super();
        articuloEspecialWS = new ArticuloEspecialPublicadorService().getArticuloEspecialPublicadorPort();
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
        
        // Mostrar formulario
        request.getRequestDispatcher("agregarArticuloEspecial.jsp").forward(request, response);
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
        if (!"BIBLIOTECARIO".equals(rol)) {
            response.sendRedirect("home.jsp?error=permisos");
            return;
        }

        // Obtener datos del formulario
        String descripcion = request.getParameter("descripcion");
        String pesoKgStr = request.getParameter("pesoKg");
        String dimensiones = request.getParameter("dimensiones");
        
        try {
            // Validar datos básicos
            if (descripcion == null || descripcion.trim().isEmpty()) {
                request.setAttribute("error", "La descripción es obligatoria");
                request.getRequestDispatcher("agregarArticuloEspecial.jsp").forward(request, response);
                return;
            }
            
            float pesoKg;
            try {
                pesoKg = Float.parseFloat(pesoKgStr);
                if (pesoKg <= 0) {
                    throw new NumberFormatException("Debe ser positivo");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "El peso debe ser un número positivo");
                request.setAttribute("descripcion", descripcion);
                request.setAttribute("dimensiones", dimensiones);
                request.getRequestDispatcher("agregarArticuloEspecial.jsp").forward(request, response);
                return;
            }
            
            if (dimensiones == null || dimensiones.trim().isEmpty()) {
                request.setAttribute("error", "Las dimensiones son obligatorias");
                request.setAttribute("descripcion", descripcion);
                request.setAttribute("pesoKg", pesoKgStr);
                request.getRequestDispatcher("agregarArticuloEspecial.jsp").forward(request, response);
                return;
            }
            
            // Llamar al Web Service
            System.out.println("=== AGREGAR ARTÍCULO ESPECIAL ===");
            System.out.println("Descripción: " + descripcion);
            System.out.println("Peso: " + pesoKg + " kg");
            System.out.println("Dimensiones: " + dimensiones);
            
            articuloEspecialWS.registrarArticuloEspecial(descripcion, pesoKg, dimensiones);
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("ListarArticulosEspeciales?success=agregar");
            
        } catch (ArticuloEspecialRepetidoException_Exception e) {
            System.out.println("Error: Artículo especial repetido - " + e.getMessage());
            request.setAttribute("error", "Ya existe un artículo especial similar registrado recientemente");
            request.setAttribute("descripcion", descripcion);
            request.setAttribute("pesoKg", pesoKgStr);
            request.setAttribute("dimensiones", dimensiones);
            request.getRequestDispatcher("agregarArticuloEspecial.jsp").forward(request, response);
            
        } catch (DatosInvalidosException_Exception e) {
            System.out.println("Error: Datos inválidos - " + e.getMessage());
            request.setAttribute("error", "Datos inválidos: " + e.getMessage());
            request.setAttribute("descripcion", descripcion);
            request.setAttribute("pesoKg", pesoKgStr);
            request.setAttribute("dimensiones", dimensiones);
            request.getRequestDispatcher("agregarArticuloEspecial.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error inesperado: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al registrar el artículo especial: " + e.getMessage());
            request.setAttribute("descripcion", descripcion);
            request.setAttribute("pesoKg", pesoKgStr);
            request.setAttribute("dimensiones", dimensiones);
            request.getRequestDispatcher("agregarArticuloEspecial.jsp").forward(request, response);
        }
    }
}

