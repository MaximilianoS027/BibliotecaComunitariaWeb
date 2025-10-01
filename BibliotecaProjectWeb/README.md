# Biblioteca Comunitaria - Cliente Web

Cliente Web que consume Web Services SOAP del servidor BibliotecaProject.

## 📋 Requisitos Previos

- **Java 11** o superior
- **Maven 3.6+**
- **Apache Tomcat 9** o servidor compatible con Servlet 4.0
- **Servidor BibliotecaProject** corriendo y publicando Web Services

## 🚀 Configuración Inicial

### 1. Verificar que el servidor esté corriendo

Antes de usar este cliente, asegúrate de que el servidor BibliotecaProject esté ejecutándose y publicando los Web Services:

```bash
# En el proyecto BibliotecaProject
cd C:\Users\maxim\Documents\pap_proyect
mvn exec:java -Dexec.mainClass="ejecutar.WebServicePrincipal"
```

Verifica que los WSDL estén disponibles:
- http://localhost:1432/lector?wsdl
- http://localhost:1432/bibliotecario?wsdl
- http://localhost:1432/libro?wsdl
- http://localhost:1432/articuloespecial?wsdl
- http://localhost:1432/prestamo?wsdl
- http://localhost:1432/autenticacion?wsdl

### 2. Generar clases cliente desde WSDL

Ejecuta el siguiente comando para generar las clases Java desde los WSDL del servidor:

```bash
cd C:\Users\maxim\Documents\BibliotecaProjectWeb

# Crear directorio para WSDLs
mkdir src\main\resources\wsdl

# Descargar los WSDLs (usa tu navegador o curl)
curl http://localhost:1432/lector?wsdl -o src/main/resources/wsdl/lector.wsdl
curl http://localhost:1432/bibliotecario?wsdl -o src/main/resources/wsdl/bibliotecario.wsdl
curl http://localhost:1432/libro?wsdl -o src/main/resources/wsdl/libro.wsdl
curl http://localhost:1432/articuloespecial?wsdl -o src/main/resources/wsdl/articuloespecial.wsdl
curl http://localhost:1432/prestamo?wsdl -o src/main/resources/wsdl/prestamo.wsdl
curl http://localhost:1432/autenticacion?wsdl -o src/main/resources/wsdl/autenticacion.wsdl

# Generar clases cliente con wsimport (Java 11)
wsimport -keep -p publicadores -s src/main/java src/main/resources/wsdl/lector.wsdl
wsimport -keep -p publicadores -s src/main/java src/main/resources/wsdl/bibliotecario.wsdl
wsimport -keep -p publicadores -s src/main/java src/main/resources/wsdl/libro.wsdl
wsimport -keep -p publicadores -s src/main/java src/main/resources/wsdl/articuloespecial.wsdl
wsimport -keep -p publicadores -s src/main/java src/main/resources/wsdl/prestamo.wsdl
wsimport -keep -p publicadores -s src/main/java src/main/resources/wsdl/autenticacion.wsdl
```

**Nota para Java 11+:** Si `wsimport` no está disponible, instala las herramientas JAX-WS:
```bash
# Descargar JAX-WS Tools
# https://mvnrepository.com/artifact/com.sun.xml.ws/jaxws-tools
```

### 3. Compilar el proyecto

```bash
mvn clean compile
```

### 4. Empaquetar el WAR

```bash
mvn clean package
```

Esto generará el archivo `target/BibliotecaWeb.war`

## 🏃 Ejecución

### Opción 1: Con Tomcat Maven Plugin (Desarrollo)

```bash
mvn tomcat7:run
```

La aplicación estará disponible en: http://localhost:8080/biblioteca

### Opción 2: Desplegar en Tomcat (Producción)

1. Copia el WAR generado al directorio webapps de Tomcat:
```bash
copy target\BibliotecaWeb.war C:\path\to\tomcat\webapps\
```

2. Inicia Tomcat:
```bash
cd C:\path\to\tomcat\bin
startup.bat
```

3. Accede a: http://localhost:8080/BibliotecaWeb

## 📁 Estructura del Proyecto

```
BibliotecaProjectWeb/
├── src/
│   └── main/
│       ├── java/
│       │   ├── publicadores/        # Clases generadas desde WSDL
│       │   └── servlets/            # Servlets
│       ├── resources/
│       │   └── wsdl/                # Archivos WSDL
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml
│           │   └── views/           # JSPs
│           ├── assets/
│           │   ├── css/             # Estilos (Flexbox responsive)
│           │   ├── js/              # jQuery + AJAX
│           │   └── img/             # Imágenes
│           └── index.jsp
├── pom.xml
└── README.md
```

## 🎨 Características

✅ **Responsive Design** con CSS Flexbox
✅ **Bootstrap 5** para componentes UI
✅ **jQuery + AJAX** para notificaciones sin recargar página
✅ **Consumo de Web Services SOAP** con Apache Axis
✅ **Autenticación con HttpSession**
✅ **JSP + Servlets** siguiendo patrón MVC

## 🔧 Tecnologías

- **Java 11**
- **Maven**
- **Servlets 4.0**
- **JSP 2.3**
- **JSTL 1.2**
- **Apache Axis 1.4** (SOAP Web Services)
- **Bootstrap 5**
- **jQuery 3.6**

## 📝 Próximos Pasos

1. Crear los servlets para cada funcionalidad
2. Crear las vistas JSP correspondientes
3. Implementar autenticación con HttpSession
4. Agregar validaciones en formularios
5. Implementar todas las historias de usuario

## 🐛 Troubleshooting

### Error: "Cannot find WSDL"
- Verifica que el servidor BibliotecaProject esté corriendo
- Confirma que los WSDLs estén accesibles en http://localhost:1432/

### Error de compilación con wsimport
- Verifica tu versión de Java: `java -version`
- Para Java 11+, necesitas instalar JAX-WS tools por separado

### Error 404 al acceder
- Verifica que Tomcat esté corriendo
- Confirma la ruta correcta (incluye el context path)

## 📞 Contacto

Para dudas o problemas, contacta al equipo de desarrollo.


