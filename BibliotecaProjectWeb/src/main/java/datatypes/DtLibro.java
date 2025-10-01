package datatypes;

import java.util.Date;

/**
 * Data Transfer Object para Libro
 * Utilizado para transferir datos de libros entre capas
 */
public class DtLibro {
    
    private String id;
    private String titulo;
    private int cantidadPaginas;
    private Date fechaRegistro;
    
    // Constructor por defecto
    public DtLibro() {}
    
    // Constructor con parámetros
    public DtLibro(String id, String titulo, int cantidadPaginas, Date fechaRegistro) {
        this.id = id;
        this.titulo = titulo;
        this.cantidadPaginas = cantidadPaginas;
        this.fechaRegistro = fechaRegistro;
    }
    
    // Getters y Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getTitulo() {
        return titulo;
    }
    
    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }
    
    public int getCantidadPaginas() {
        return cantidadPaginas;
    }
    
    public void setCantidadPaginas(int cantidadPaginas) {
        this.cantidadPaginas = cantidadPaginas;
    }
    
    public Date getFechaRegistro() {
        return fechaRegistro;
    }
    
    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
    @Override
    public String toString() {
        return "DtLibro{" +
                "id='" + id + '\'' +
                ", titulo='" + titulo + '\'' +
                ", cantidadPaginas=" + cantidadPaginas +
                ", fechaRegistro=" + fechaRegistro +
                '}';
    }
}
