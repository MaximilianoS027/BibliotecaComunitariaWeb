package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import publicadores.lector.LectorPublicadorService;
import publicadores.lector.LectorPublicador;
import publicadores.lector.LectorRepetidoException_Exception;
import publicadores.lector.DatosInvalidosException_Exception;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet para registrar nuevos lectores
 * Solo accesible para usuarios con rol BIBLIOTECARIO
 */
@WebServlet("/RegistroLector")
public class RegistroLectorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LectorPublicador lectorWS;

    public RegistroLectorServlet() {
        super();
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
        
        // Mostrar formulario
        request.getRequestDispatcher("registro.jsp").forward(request, response);
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
        
        // Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String direccion = request.getParameter("direccion");
        String estado = request.getParameter("estado");
        String zona = request.getParameter("zona");
        
        try {
            // Validar datos básicos
            if (nombre == null || nombre.trim().isEmpty()) {
                request.setAttribute("error", "El nombre es obligatorio");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "El email es obligatorio");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "La contraseña es obligatoria");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Las contraseñas no coinciden");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            if (direccion == null || direccion.trim().isEmpty()) {
                request.setAttribute("error", "La dirección es obligatoria");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            if (estado == null || estado.trim().isEmpty()) {
                request.setAttribute("error", "El estado es obligatorio");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            if (zona == null || zona.trim().isEmpty()) {
                request.setAttribute("error", "La zona es obligatoria");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }
            
            // Generar fecha de registro actual
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String fechaRegistro = sdf.format(new Date());
            
            // Llamar al Web Service
            System.out.println("=== REGISTRAR LECTOR ===");
            System.out.println("Nombre: " + nombre);
            System.out.println("Email: " + email);
            System.out.println("Dirección: " + direccion);
            System.out.println("Estado: " + estado);
            System.out.println("Zona: " + zona);
            
            lectorWS.registrarLectorConPassword(nombre, email, password, direccion, 
                                              fechaRegistro, estado, zona);
            
            // Redirigir con mensaje de éxito
            response.sendRedirect("ListarLectores?success=registro");
            
        } catch (LectorRepetidoException_Exception e) {
            System.out.println("Error: Lector repetido - " + e.getMessage());
            request.setAttribute("error", "Ya existe un lector con ese email");
            request.setAttribute("nombre", nombre);
            request.setAttribute("email", email);
            request.setAttribute("direccion", direccion);
            request.setAttribute("estado", estado);
            request.setAttribute("zona", zona);
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            
        } catch (DatosInvalidosException_Exception e) {
            System.out.println("Error: Datos inválidos - " + e.getMessage());
            request.setAttribute("error", "Los datos proporcionados no son válidos: " + e.getMessage());
            request.setAttribute("nombre", nombre);
            request.setAttribute("email", email);
            request.setAttribute("direccion", direccion);
            request.setAttribute("estado", estado);
            request.setAttribute("zona", zona);
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR en RegistroLectorServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al registrar el lector: " + e.getMessage());
            request.setAttribute("nombre", nombre);
            request.setAttribute("email", email);
            request.setAttribute("direccion", direccion);
            request.setAttribute("estado", estado);
            request.setAttribute("zona", zona);
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}
