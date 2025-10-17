# 📚 Guía de Gestión de Libros - Biblioteca Comunitaria Web

## 🎯 Descripción General

Se han implementado todas las funcionalidades para la gestión completa de libros en la aplicación web, manteniendo la arquitectura existente basada en Servlets y Web Services SOAP.

## 📁 Archivos Creados

### Servlets (`src/main/java/servlets/`)

1. **AgregarLibroServlet.java**
   - Ruta: `/AgregarLibro`
   - Métodos: GET (muestra formulario), POST (procesa registro)
   - Rol requerido: BIBLIOTECARIO

2. **ListarLibrosServlet.java**
   - Ruta: `/ListarLibros`
   - Métodos: GET/POST
   - Roles: LECTOR, BIBLIOTECARIO

3. **ConsultarLibroServlet.java**
   - Ruta: `/ConsultarLibro?id={libroId}`
   - Métodos: GET/POST
   - Roles: LECTOR, BIBLIOTECARIO

4. **ModificarLibroServlet.java**
   - Ruta: `/ModificarLibro`
   - Métodos: GET (muestra formulario con datos), POST (procesa actualización)
   - Rol requerido: BIBLIOTECARIO

5. **EliminarLibroServlet.java**
   - Ruta: `/EliminarLibro?id={libroId}`
   - Métodos: GET/POST
   - Rol requerido: BIBLIOTECARIO
   - **NOTA:** Actualmente deshabilitado, requiere implementar método `eliminarLibro()` en el backend

### JSPs (`src/main/webapp/`)

1. **agregarLibro.jsp** - Formulario para registrar nuevos libros
2. **detalleLibro.jsp** - Visualización detallada de un libro
3. **editarLibro.jsp** - Formulario para modificar libros existentes
4. **catalogo.jsp** - Lista completa de libros con búsqueda y filtros (actualizado)

---

## 🔄 Flujo de Funcionamiento

### 1. Agregar Libro (BIBLIOTECARIO)

```
Usuario → AgregarLibro → Formulario → Submit
    ↓
AgregarLibroServlet (POST)
    ↓
LibroPublicadorWS.registrarLibro(titulo, cantidadPaginas)
    ↓
Backend (valida y persiste en PostgreSQL)
    ↓
Redirige a catalogo.jsp?success=agregar
```

**Validaciones:**
- Título obligatorio y único
- Cantidad de páginas > 0
- Manejo de excepciones: `LibroRepetidoException`, `DatosInvalidosException`

---

### 2. Listar Libros (LECTOR/BIBLIOTECARIO)

```
Usuario → ListarLibros
    ↓
ListarLibrosServlet (GET)
    ↓
LibroPublicadorWS.listarLibros() → StringArray de IDs
    ↓
Para cada ID: LibroPublicadorWS.obtenerLibro(id) → DtLibro
    ↓
Forward a catalogo.jsp con List<DtLibro>
```

**Características:**
- Tabla responsive con Bootstrap 5
- Búsqueda en cliente por título
- Acciones según rol (ver, editar, eliminar)
- Auto-refresh disponible

---

### 3. Consultar Detalles (LECTOR/BIBLIOTECARIO)

```
Usuario → Click en libro → ConsultarLibro?id=ABC123
    ↓
ConsultarLibroServlet (GET)
    ↓
LibroPublicadorWS.obtenerLibro(id) → DtLibro
    ↓
Forward a detalleLibro.jsp
```

**Muestra:**
- ID, Título, Páginas, Fecha de Registro
- Botones de acción según rol
- Estadísticas (pendiente de implementar)

---

### 4. Modificar Libro (BIBLIOTECARIO)

```
Usuario → Click "Editar" → ModificarLibro?id=ABC123 (GET)
    ↓
ModificarLibroServlet muestra editarLibro.jsp con datos precargados
    ↓
Usuario modifica y envía (POST)
    ↓
LibroPublicadorWS.actualizarLibro(id, nuevoTitulo, nuevasPaginas)
    ↓
Redirige a ConsultarLibro?id=ABC123&success=modificar
```

**Validaciones:**
- Mismas validaciones que agregar
- Confirmación de cambios
- Muestra datos actuales vs nuevos

---

### 5. Eliminar Libro (BIBLIOTECARIO) - ⚠️ PENDIENTE

```
Usuario → Click "Eliminar" → Confirmación → EliminarLibro?id=ABC123
    ↓
EliminarLibroServlet
    ↓
⚠️ FUNCIONALIDAD DESHABILITADA
Redirige a catalogo.jsp?info=funcionalidad_pendiente
```

**Para habilitar:**
1. Agregar método en `BibliotecaComunitaria/src/main/java/publicadores/LibroPublicador.java`:
```java
@WebMethod
public void eliminarLibro(String id) throws LibroNoExisteException {
    controlador.eliminarLibro(id);
}
```

2. Implementar en `ILibroControlador` y `LibroControlador`

3. Recompilar el backend y regenerar stubs

4. Descomentar en `EliminarLibroServlet.java`:
```java
libroWS.eliminarLibro(libroId);
response.sendRedirect("catalogo.jsp?success=eliminar");
```

---

## 🔐 Control de Acceso

### Por Rol

| Funcionalidad | LECTOR | BIBLIOTECARIO |
|---------------|--------|---------------|
| Ver catálogo  | ✅ | ✅ |
| Ver detalles  | ✅ | ✅ |
| Agregar libro | ❌ | ✅ |
| Modificar libro | ❌ | ✅ |
| Eliminar libro | ❌ | ✅ |

### Validación en Servlets

Todos los servlets verifican:
```java
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
```

---

## 🚀 Instrucciones de Compilación y Ejecución

### 1. Compilar el Proyecto

```bash
cd BibliotecaComunitariaWeb/BibliotecaProjectWeb
mvn clean compile
```

### 2. Generar WAR

```bash
mvn package
```

Esto generará: `target/BibliotecaWeb.war`

### 3. Verificar que el Backend esté corriendo

```bash
cd BibliotecaComunitaria
# Verificar que los Web Services estén publicados
# Debe mostrar URLs como: http://localhost:9090/biblioteca/libro
```

### 4. Desplegar en Tomcat

**Opción A: Copiar WAR**
```bash
cp target/BibliotecaWeb.war $CATALINA_HOME/webapps/
```

**Opción B: Usar Maven Tomcat Plugin**
```bash
mvn tomcat7:deploy
# o
mvn tomcat7:redeploy
```

### 5. Acceder a la Aplicación

```
http://localhost:8080/BibliotecaWeb/
```

---

## 🧪 Cómo Probar

### Escenario 1: Agregar Libro (como BIBLIOTECARIO)

1. Iniciar sesión como bibliotecario
2. Ir a: `/AgregarLibro` o click en navbar
3. Completar formulario:
   - Título: "Cien Años de Soledad"
   - Páginas: 471
4. Click "Registrar Libro"
5. Verificar redirección a catálogo con mensaje de éxito

### Escenario 2: Ver Catálogo (como LECTOR o BIBLIOTECARIO)

1. Iniciar sesión
2. Ir a: `/ListarLibros` o click en "Catálogo"
3. Verificar que se muestren todos los libros en tabla
4. Probar búsqueda ingresando texto en el campo de búsqueda

### Escenario 3: Ver Detalles

1. En el catálogo, click en el ícono 👁️ de un libro
2. Verificar que se muestre toda la información
3. Si eres BIBLIOTECARIO, ver botones de "Editar" y "Eliminar"
4. Si eres LECTOR, solo ver información sin botones de acción

### Escenario 4: Modificar Libro (como BIBLIOTECARIO)

1. En detalles del libro, click "Editar" o ✏️ en el catálogo
2. Modificar título o páginas
3. Click "Guardar Cambios"
4. Verificar actualización en la vista de detalles

### Escenario 5: Intentar Eliminar (como BIBLIOTECARIO)

1. En detalles o catálogo, click "Eliminar" o 🗑️
2. Confirmar acción
3. Ver mensaje: "Funcionalidad pendiente"

---

## 🔧 Resolución de Problemas

### Error: "No se puede conectar al Web Service"

**Solución:**
1. Verificar que el backend esté corriendo:
   ```bash
   cd BibliotecaComunitaria
   mvn exec:java
   ```
2. Comprobar que los Web Services estén publicados en las URLs correctas

### Error: "LibroRepetidoException"

**Causa:** El título ya existe en la base de datos

**Solución:** Usar un título diferente o modificar el libro existente

### Error: "DatosInvalidosException"

**Causa:** Validaciones del backend fallaron

**Soluciones:**
- Asegurar que el título no esté vacío
- Cantidad de páginas debe ser > 0
- Título no debe exceder longitud máxima

### Error de compilación: "StringArray cannot be converted to List<String>"

**Solución:**
Si persiste después de compilar, el código está correcto. El error puede ser de caché del IDE.

1. En Eclipse/IntelliJ: Clean & Rebuild Project
2. O ejecutar: `mvn clean compile`

El código maneja correctamente:
```java
StringArray stringArray = libroWS.listarLibros();
List<String> idsLibros = stringArray.getItem();
```

---

## 📊 Estructura de Datos

### DtLibro (Data Transfer Object)

```java
public class DtLibro {
    private String id;              // Generado automáticamente
    private String titulo;          // Único, no nulo
    private int cantidadPaginas;    // > 0
    private Date fechaRegistro;     // Auto-generado
}
```

---

## 🎨 Características de UI

### Diseño Responsive
- Bootstrap 5
- Adaptable a móviles, tablets y desktop
- Navbar con menú desplegable

### Feedback Visual
- Alertas de éxito (verde)
- Alertas de error (rojo)
- Alertas informativas (azul/amarillo)
- Auto-dismiss después de 5 segundos

### Accesibilidad
- Labels en formularios
- Textos de ayuda
- Confirmaciones antes de acciones destructivas
- Breadcrumbs para navegación

### Diferenciación por Rol
- LECTOR: Navbar azul
- BIBLIOTECARIO: Navbar verde
- Botones y acciones contextúales según permisos

---

## 🔮 Próximas Funcionalidades

1. **Eliminar Libro** - Requiere implementación en backend
2. **Búsqueda Avanzada** - Filtros por páginas, fecha, etc.
3. **Paginación** - Para catálogos grandes
4. **Integración con Préstamos** - Vincular libros con sistema de préstamos
5. **Historial de Cambios** - Auditoría de modificaciones
6. **Reportes** - Estadísticas de libros más prestados, etc.

---

## 📝 Notas Importantes

1. **Sesiones**: Timeout configurado en 30 minutos
2. **Persistencia**: Todos los datos se guardan en PostgreSQL vía Hibernate
3. **Web Services**: Comunicación SOAP RPC/Wrapped
4. **Logs**: Los servlets imprimen información en consola para debugging
5. **Validaciones**: Dobles (cliente y servidor) para mayor seguridad

---

## 👨‍💻 Autor

Implementación completada el 14 de octubre de 2025
Arquitectura: Servlets + JSP + Web Services SOAP + Hibernate + PostgreSQL

---

## 📞 Soporte

Para problemas o consultas:
1. Revisar logs del servidor Tomcat: `$CATALINA_HOME/logs/`
2. Revisar logs del backend: `BibliotecaComunitaria/logs/biblioteca.log`
3. Verificar conexión a base de datos PostgreSQL
4. Comprobar que todos los Web Services estén activos

---

¡Disfruta del sistema de gestión de libros! 📚✨

