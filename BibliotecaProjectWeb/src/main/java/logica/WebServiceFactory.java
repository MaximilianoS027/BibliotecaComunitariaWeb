package logica;

import publicadores.lector.LectorPublicadorService;
import publicadores.lector.LectorPublicador;
import publicadores.bibliotecario.BibliotecarioPublicadorService;
import publicadores.bibliotecario.BibliotecarioPublicador;
import publicadores.libro.LibroPublicadorService;
import publicadores.libro.LibroPublicador;
import publicadores.articuloespecial.ArticuloEspecialPublicadorService;
import publicadores.articuloespecial.ArticuloEspecialPublicador;
import publicadores.prestamo.PrestamoPublicadorService;
import publicadores.prestamo.PrestamoPublicador;
import publicadores.autenticacion.AutenticacionPublicadorService;
import publicadores.autenticacion.AutenticacionPublicador;

/**
 * Factory para obtener instancias singleton de los Web Services.
 * Reduce el overhead de crear múltiples conexiones SOAP.
 * Los stubs de JAX-WS son thread-safe, por lo que es seguro compartir instancias.
 */
public class WebServiceFactory {
    
    // Instancias singleton de cada Web Service
    private static volatile LectorPublicador lectorWS;
    private static volatile BibliotecarioPublicador bibliotecarioWS;
    private static volatile LibroPublicador libroWS;
    private static volatile ArticuloEspecialPublicador articuloWS;
    private static volatile PrestamoPublicador prestamoWS;
    private static volatile AutenticacionPublicador autenticacionWS;
    
    // Constructor privado para prevenir instanciación
    private WebServiceFactory() {
        throw new AssertionError("No se debe instanciar WebServiceFactory");
    }
    
    /**
     * Obtiene la instancia singleton del servicio de Lector
     */
    public static LectorPublicador getLectorService() {
        if (lectorWS == null) {
            synchronized (WebServiceFactory.class) {
                if (lectorWS == null) {
                    lectorWS = new LectorPublicadorService().getLectorPublicadorPort();
                }
            }
        }
        return lectorWS;
    }
    
    /**
     * Obtiene la instancia singleton del servicio de Bibliotecario
     */
    public static BibliotecarioPublicador getBibliotecarioService() {
        if (bibliotecarioWS == null) {
            synchronized (WebServiceFactory.class) {
                if (bibliotecarioWS == null) {
                    bibliotecarioWS = new BibliotecarioPublicadorService().getBibliotecarioPublicadorPort();
                }
            }
        }
        return bibliotecarioWS;
    }
    
    /**
     * Obtiene la instancia singleton del servicio de Libro
     */
    public static LibroPublicador getLibroService() {
        if (libroWS == null) {
            synchronized (WebServiceFactory.class) {
                if (libroWS == null) {
                    libroWS = new LibroPublicadorService().getLibroPublicadorPort();
                }
            }
        }
        return libroWS;
    }
    
    /**
     * Obtiene la instancia singleton del servicio de Artículo Especial
     */
    public static ArticuloEspecialPublicador getArticuloEspecialService() {
        if (articuloWS == null) {
            synchronized (WebServiceFactory.class) {
                if (articuloWS == null) {
                    articuloWS = new ArticuloEspecialPublicadorService().getArticuloEspecialPublicadorPort();
                }
            }
        }
        return articuloWS;
    }
    
    /**
     * Obtiene la instancia singleton del servicio de Préstamo
     */
    public static PrestamoPublicador getPrestamoService() {
        if (prestamoWS == null) {
            synchronized (WebServiceFactory.class) {
                if (prestamoWS == null) {
                    prestamoWS = new PrestamoPublicadorService().getPrestamoPublicadorPort();
                }
            }
        }
        return prestamoWS;
    }
    
    /**
     * Obtiene la instancia singleton del servicio de Autenticación
     */
    public static AutenticacionPublicador getAutenticacionService() {
        if (autenticacionWS == null) {
            synchronized (WebServiceFactory.class) {
                if (autenticacionWS == null) {
                    autenticacionWS = new AutenticacionPublicadorService().getAutenticacionPublicadorPort();
                }
            }
        }
        return autenticacionWS;
    }
    
    /**
     * Reinicia todas las conexiones de Web Services.
     * Útil si el servidor SOAP se reinicia.
     */
    public static synchronized void resetAll() {
        lectorWS = null;
        bibliotecarioWS = null;
        libroWS = null;
        articuloWS = null;
        prestamoWS = null;
        autenticacionWS = null;
    }
}


