# ✅ Checklist de Despliegue - Gestión de Libros

## Pre-requisitos

- [ ] JDK 17+ instalado
- [ ] Maven instalado
- [ ] Apache Tomcat 9+ instalado
- [ ] PostgreSQL corriendo
- [ ] Base de datos configurada

---

## Paso 1: Verificar Backend

```bash
cd BibliotecaComunitaria
```

- [ ] Verificar `src/main/resources/database-postgresql.properties`
- [ ] Compilar: `mvn clean compile`
- [ ] Ejecutar: `mvn exec:java`
- [ ] Verificar en consola: "Servicio Libro publicado en: http://localhost:9090/biblioteca/libro"
- [ ] Probar WSDL: http://localhost:9090/biblioteca/libro?wsdl

---

## Paso 2: Compilar Aplicación Web

```bash
cd BibliotecaComunitariaWeb/BibliotecaProjectWeb
```

- [ ] Limpiar: `mvn clean`
- [ ] Compilar: `mvn compile`
- [ ] Empaquetar: `mvn package`
- [ ] Verificar WAR generado en: `target/BibliotecaWeb.war`

---

## Paso 3: Desplegar en Tomcat

**Opción A: Manual**
```bash
cp target/BibliotecaWeb.war $CATALINA_HOME/webapps/
```

**Opción B: Manager de Tomcat**
- [ ] Acceder a http://localhost:8080/manager
- [ ] Subir `BibliotecaWeb.war`

- [ ] Esperar despliegue automático
- [ ] Verificar carpeta `BibliotecaWeb` en `webapps/`

---

## Paso 4: Verificar Despliegue

- [ ] Acceder a: http://localhost:8080/BibliotecaWeb/
- [ ] Debería mostrar página de login
- [ ] Verificar logs: `$CATALINA_HOME/logs/catalina.out`
- [ ] No debe haber errores de conexión al WS

---

## Paso 5: Probar Funcionalidades

### Como BIBLIOTECARIO

1. **Login**
   - [ ] Usar credenciales de bibliotecario
   - [ ] Verificar redirección a home.jsp
   - [ ] Navbar debe ser verde

2. **Agregar Libro**
   - [ ] Click en "Agregar Libro" o ir a `/AgregarLibro`
   - [ ] Completar formulario:
     - Título: "Don Quijote de la Mancha"
     - Páginas: 863
   - [ ] Click "Registrar Libro"
   - [ ] Verificar mensaje: "El libro ha sido agregado correctamente"

3. **Ver Catálogo**
   - [ ] Click en "Catálogo" o ir a `/ListarLibros`
   - [ ] Verificar que aparece el libro agregado
   - [ ] Tabla debe mostrar: ID, Título, Páginas, Fecha
   - [ ] Acciones disponibles: 👁️ ✏️ 🗑️

4. **Ver Detalles**
   - [ ] Click en 👁️ del libro
   - [ ] Verificar todos los datos se muestran
   - [ ] Botones "Editar" y "Eliminar" visibles

5. **Modificar Libro**
   - [ ] Click en "Editar" o ✏️
   - [ ] Modificar páginas a: 900
   - [ ] Click "Guardar Cambios"
   - [ ] Confirmar acción
   - [ ] Verificar mensaje: "El libro ha sido modificado correctamente"
   - [ ] Verificar cambio en vista de detalle


### Como LECTOR

1. **Login**
   - [ ] Usar credenciales de lector
   - [ ] Navbar debe ser azul

2. **Ver Catálogo**
   - [ ] Click en "Catálogo"
   - [ ] Ver lista de libros
   - [ ] Solo acción visible: 👁️ (ver detalles)
   - [ ] NO debe ver: ✏️ (editar)

3. **Ver Detalles**
   - [ ] Click en 👁️
   - [ ] Ver información completa
   - [ ] NO debe ver botones "Editar" ni "Eliminar"

4. **Intentar Acceso Directo**
   - [ ] Ir manualmente a: `/AgregarLibro`
   - [ ] Debe redirigir a: `home.jsp?error=permisos`
   - [ ] Mensaje de error de permisos

---

## Paso 6: Probar Búsqueda

- [ ] En catálogo, escribir en buscador: "quijote"
- [ ] Presionar "Buscar"
- [ ] Verificar que filtra correctamente
- [ ] Limpiar búsqueda para ver todos

---

## Paso 7: Verificar Responsive

- [ ] Abrir DevTools (F12)
- [ ] Toggle device toolbar (Ctrl+Shift+M)
- [ ] Probar en:
  - [ ] iPhone SE (375px)
  - [ ] iPad (768px)
  - [ ] Desktop (1920px)
- [ ] Navbar debe colapsar en móvil
- [ ] Tabla debe ser scrollable en móvil
- [ ] Botones deben adaptarse

---

## Paso 8: Verificar Persistencia

- [ ] Agregar un libro
- [ ] Cerrar sesión
- [ ] Reiniciar Tomcat
- [ ] Login nuevamente
- [ ] Verificar que el libro sigue en catálogo

---

## Solución de Problemas

### ❌ Error: "Cannot connect to Web Service"

**Solución:**
1. Verificar backend está corriendo: `netstat -an | grep 9090`
2. Verificar URL en logs del backend
3. Ping al servicio: `curl http://localhost:9090/biblioteca/libro?wsdl`

### ❌ Error: "404 - BibliotecaWeb not found"

**Solución:**
1. Verificar WAR en `webapps/`
2. Revisar logs: `tail -f $CATALINA_HOME/logs/catalina.out`
3. Verificar permisos del archivo WAR
4. Intentar despliegue manual

### ❌ Error: "500 - Internal Server Error"

**Solución:**
1. Revisar logs de Tomcat
2. Verificar conexión a base de datos
3. Verificar stubs generados correctamente
4. Limpiar y recompilar: `mvn clean package`

### ❌ Libro no se agrega

**Solución:**
1. Verificar backend recibe petición (logs)
2. Verificar base de datos tiene permisos
3. Verificar título no existe ya
4. Revisar validaciones en consola del navegador

### ❌ Catálogo vacío

**Solución:**
1. Verificar hay libros en BD: `SELECT * FROM libro;`
2. Verificar método `listarLibros()` funciona en backend
3. Revisar logs del servlet
4. Verificar conversión StringArray → List<String>

---

## Verificación Final

### ✅ Criterios de Aceptación

- [ ] Login funciona correctamente
- [ ] Control de roles implementado correctamente
- [ ] SOLO BIBLIOTECARIO puede agregar libros (donaciones)
- [ ] SOLO BIBLIOTECARIO puede modificar libros
- [ ] Catálogo muestra todos los libros
- [ ] Detalles se muestran correctamente
- [ ] LECTOR solo puede ver información (no editar)
- [ ] Búsqueda funciona
- [ ] Diseño responsive
- [ ] Persistencia en base de datos
- [ ] Mensajes de feedback claros
- [ ] No hay errores en consola del navegador
- [ ] No hay errores en logs de servidor

---

## Logs a Revisar

```bash
# Backend
tail -f BibliotecaComunitaria/logs/biblioteca.log

# Tomcat
tail -f $CATALINA_HOME/logs/catalina.out

# Tomcat Errors
tail -f $CATALINA_HOME/logs/localhost.*.log
```

---

## Comandos Útiles

### Reiniciar Backend
```bash
cd BibliotecaComunitaria
pkill -f "java.*BibliotecaComunitaria"
mvn exec:java &
```

### Reiniciar Tomcat
```bash
$CATALINA_HOME/bin/shutdown.sh
$CATALINA_HOME/bin/startup.sh
```

### Limpiar y Redesplegar
```bash
cd BibliotecaComunitariaWeb/BibliotecaProjectWeb
mvn clean package
rm -rf $CATALINA_HOME/webapps/BibliotecaWeb*
cp target/BibliotecaWeb.war $CATALINA_HOME/webapps/
```

### Ver Procesos Java
```bash
jps -l
```

### Verificar Puertos
```bash
netstat -an | grep 8080  # Tomcat
netstat -an | grep 9090  # Backend WS
netstat -an | grep 5432  # PostgreSQL
```

---

## 📊 Métricas de Éxito

Una vez completado el checklist:

- **Funcionalidades operativas:** 4/4 (100%)
  - ✅ Registrar donación
  - ✅ Listar catálogo
  - ✅ Consultar detalles
  - ✅ Modificar libro

- **Roles implementados:** 2/2 (100%)
  - ✅ LECTOR (permisos correctos)
  - ✅ BIBLIOTECARIO (permisos completos)

- **UI/UX:** 100%
  - ✅ Responsive
  - ✅ Feedback claro
  - ✅ Navegación intuitiva

---

## 🎉 ¡Felicitaciones!

Si todos los checks están marcados, la implementación está completa y funcional.

**Sistema listo:** Todas las funcionalidades necesarias están implementadas y operativas.

---

*Checklist v1.0 - 14/10/2025*

