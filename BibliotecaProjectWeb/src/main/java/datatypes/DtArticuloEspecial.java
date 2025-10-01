package datatypes;

import java.util.Date;

/**
 * Data Transfer Object para ArticuloEspecial
 * Utilizado para transferir datos de artículos especiales entre capas
 */
public class DtArticuloEspecial {
    
    private String id;
    private String descripcion;
    private float pesoKg;
    private String dimensiones;
    private Date fechaRegistro;
    
    // Constructor por defecto
    public DtArticuloEspecial() {}
    
    // Constructor con parámetros
    public DtArticuloEspecial(String id, String descripcion, float pesoKg, String dimensiones, Date fechaRegistro) {
        this.id = id;
        this.descripcion = descripcion;
        this.pesoKg = pesoKg;
        this.dimensiones = dimensiones;
        this.fechaRegistro = fechaRegistro;
    }
    
    // Getters y Setters
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public float getPesoKg() {
        return pesoKg;
    }
    
    public void setPesoKg(float pesoKg) {
        this.pesoKg = pesoKg;
    }
    
    public String getDimensiones() {
        return dimensiones;
    }
    
    public void setDimensiones(String dimensiones) {
        this.dimensiones = dimensiones;
    }
    
    public Date getFechaRegistro() {
        return fechaRegistro;
    }
    
    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
    
    @Override
    public String toString() {
        return "DtArticuloEspecial{" +
                "id='" + id + '\'' +
                ", descripcion='" + descripcion + '\'' +
                ", pesoKg=" + pesoKg +
                ", dimensiones='" + dimensiones + '\'' +
                ", fechaRegistro=" + fechaRegistro +
                '}';
    }
}
