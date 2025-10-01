package logica;

/**
 * Enumeración que representa las diferentes zonas de la biblioteca
 */
public enum Zona {
    BIBLIOTECA_CENTRAL("Biblioteca Central"),
    SUCURSAL_ESTE("Sucursal Este"),
    SUCURSAL_OESTE("Sucursal Oeste"),
    BIBLIOTECA_INFANTIL("Biblioteca Infantil"),
    ARCHIVO_GENERAL("Archivo General");
    
    private final String descripcion;
    
    Zona(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    @Override
    public String toString() {
        return descripcion;
    }
}
