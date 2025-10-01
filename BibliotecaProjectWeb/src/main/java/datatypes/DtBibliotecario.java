package datatypes;

/**
 * Data Transfer Object para Bibliotecario
 * Representa los datos de un bibliotecario para transferencia
 */
public class DtBibliotecario {
    private String numeroEmpleado;
    private String nombre;
    private String email;
    private String password; // Solo para transferencia, no se almacena el hash
    
    // Constructor por defecto
    public DtBibliotecario() {}
    
    // Constructor sin password
    public DtBibliotecario(String numeroEmpleado, String nombre, String email) {
        this.numeroEmpleado = numeroEmpleado;
        this.nombre = nombre;
        this.email = email;
    }
    
    // Constructor con password
    public DtBibliotecario(String numeroEmpleado, String nombre, String email, String password) {
        this.numeroEmpleado = numeroEmpleado;
        this.nombre = nombre;
        this.email = email;
        this.password = password;
    }
    
    public String getNumeroEmpleado() { 
        return numeroEmpleado; 
    }
    
    public void setNumeroEmpleado(String numeroEmpleado) {
        this.numeroEmpleado = numeroEmpleado;
    }
    
    public String getNombre() { 
        return nombre; 
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    @Override
    public String toString() {
        return "NUMERO EMPLEADO = " + numeroEmpleado + 
               "\nNOMBRE = " + nombre + 
               "\nEMAIL = " + email;
    }
}
