package datatypes;

import java.util.Date;

/**
 * Data Transfer Object para la entidad Prestamo
 */
public class DtPrestamo {
    
    private String id;
    private Date fechaSolicitud;
    private Date fechaDevolucion;
    private String estado;
    private String lectorId;
    private String lectorNombre;
    private String bibliotecarioId;
    private String bibliotecarioNombre;
    private String materialId;
    private String materialTipo;
    private String materialDescripcion;
    
    // Constructor por defecto
    public DtPrestamo() {}
    
    // Constructor con parámetros
    public DtPrestamo(String id, Date fechaSolicitud, Date fechaDevolucion, String estado,
                     String lectorId, String lectorNombre, String bibliotecarioId, String bibliotecarioNombre,
                     String materialId, String materialTipo, String materialDescripcion) {
        this.id = id;
        this.fechaSolicitud = fechaSolicitud;
        this.fechaDevolucion = fechaDevolucion;
        this.estado = estado;
        this.lectorId = lectorId;
        this.lectorNombre = lectorNombre;
        this.bibliotecarioId = bibliotecarioId;
        this.bibliotecarioNombre = bibliotecarioNombre;
        this.materialId = materialId;
        this.materialTipo = materialTipo;
        this.materialDescripcion = materialDescripcion;
    }
    
    // Getters y Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public Date getFechaSolicitud() {
        return fechaSolicitud;
    }
    
    public void setFechaSolicitud(Date fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }
    
    public Date getFechaDevolucion() {
        return fechaDevolucion;
    }
    
    public void setFechaDevolucion(Date fechaDevolucion) {
        this.fechaDevolucion = fechaDevolucion;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    public String getLectorId() {
        return lectorId;
    }
    
    public void setLectorId(String lectorId) {
        this.lectorId = lectorId;
    }
    
    public String getLectorNombre() {
        return lectorNombre;
    }
    
    public void setLectorNombre(String lectorNombre) {
        this.lectorNombre = lectorNombre;
    }
    
    public String getBibliotecarioId() {
        return bibliotecarioId;
    }
    
    public void setBibliotecarioId(String bibliotecarioId) {
        this.bibliotecarioId = bibliotecarioId;
    }
    
    public String getBibliotecarioNombre() {
        return bibliotecarioNombre;
    }
    
    public void setBibliotecarioNombre(String bibliotecarioNombre) {
        this.bibliotecarioNombre = bibliotecarioNombre;
    }
    
    public String getMaterialId() {
        return materialId;
    }
    
    public void setMaterialId(String materialId) {
        this.materialId = materialId;
    }
    
    public String getMaterialTipo() {
        return materialTipo;
    }
    
    public void setMaterialTipo(String materialTipo) {
        this.materialTipo = materialTipo;
    }
    
    public String getMaterialDescripcion() {
        return materialDescripcion;
    }
    
    public void setMaterialDescripcion(String materialDescripcion) {
        this.materialDescripcion = materialDescripcion;
    }
    
    @Override
    public String toString() {
        return "DtPrestamo{" +
                "id='" + id + '\'' +
                ", fechaSolicitud=" + fechaSolicitud +
                ", fechaDevolucion=" + fechaDevolucion +
                ", estado='" + estado + '\'' +
                ", lectorNombre='" + lectorNombre + '\'' +
                ", bibliotecarioNombre='" + bibliotecarioNombre + '\'' +
                ", materialDescripcion='" + materialDescripcion + '\'' +
                '}';
    }
}
