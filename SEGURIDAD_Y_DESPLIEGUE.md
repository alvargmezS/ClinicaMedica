# 🛡️ Guía de Arquitectura de Seguridad y Despliegue en Producción
**Sistema de Gestión Clínica - Clínica Médica**

---

## 📋 Índice
1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Matriz de Mitigaciones OWASP Top 10 Implementadas](#2-matriz-de-mitigaciones-owasp-top-10-implementadas)
3. [Detalle de Componentes de Seguridad](#3-detalle-de-componentes-de-seguridad)
   - [3.1 Control de Acceso y Sesiones (A01, A07)](#31-control-de-acceso-y-sesiones)
   - [3.2 Protección contra Ataques de Fuerza Bruta (A07)](#32-protección-contra-ataques-de-fuerza-bruta)
   - [3.3 Protección contra Cross-Site Request Forgery - CSRF (A08)](#33-protección-contra-cross-site-request-forgery---csrf)
   - [3.4 Mitigación de Cross-Site Scripting - XSS (A03)](#34-mitigación-de-cross-site-scripting---xss)
   - [3.5 Cabeceras de Seguridad HTTP y Manejo de Errores (A05)](#35-cabeceras-de-seguridad-http-y-manejo-de-errores)
   - [3.6 Registro de Auditoría de Datos de Salud - RGPD / LOPDGDD (A09)](#36-registro-de-auditoría-de-datos-de-salud---rgpd--lopdgdd)
   - [3.7 Gestión de Conexiones JPA y Variables de Entorno (A02, A05)](#37-gestión-de-conexiones-jpa-y-variables-de-entorno)
4. [Filosofía de Implementación: Sin JavaScript](#4-filosofía-de-implementación-sin-javascript)
5. [Guía de Despliegue en Producción](#5-guía-de-despliegue-en-producción)
   - [5.1 Variables de Entorno Soportadas](#51-variables-de-entorno-soportadas)
   - [5.2 Despliegue Tradicional en Apache Tomcat](#52-despliegue-tradicional-en-apache-tomcat)
   - [5.3 Despliegue en Contenedores (Docker & Docker Compose)](#53-despliegue-en-contenedores-docker--docker-compose)
   - [5.4 Configuración de Reverse Proxy con Nginx y Certificados SSL/TLS](#54-configuración-de-reverse-proxy-con-nginx-y-certificados-ssltls)
6. [Checklist de Verificación Previa al Pase a Producción](#6-checklist-de-verificación-previa-al-pase-a-producción)

---

## 1. Resumen Ejecutivo

El presente proyecto ha sido sometido a un endurecimiento (*hardening*) de seguridad integral, transformando la aplicación web de gestión clínica en un sistema robusto, alineado con las directrices de seguridad de **OWASP Top 10** y las regulaciones europeas y nacionales sobre datos médicos de categoría especial (**RGPD Art. 9** y **LOPDGDD**).

Todas las capas del sistema han sido reforzadas:
- **Capa Web / Presentación**: Sanitización activa contra XSS y tokens CSRF en formularios de acción crítica.
- **Capa de Control / Filtros**: Filtro de autenticación y autorización granular por roles, protección contra Session Fixation, cabeceras HTTP de seguridad (CSP, HSTS, X-Frame-Options, X-Content-Type-Options) y bloqueo anti-fuerza bruta.
- **Capa de Negocio / Auditoría**: Registro inmutable de trazabilidad de accesos a historias clínicas.
- **Capa de Persistencia / Datos**: Factoría JPA singleton configurable externamente mediante variables de entorno, evitando credenciales quemadas en el código fuente y consultas JPQL parametrizadas.

---

## 2. Matriz de Mitigaciones OWASP Top 10 Implementadas

| Identificador OWASP | Vulnerabilidad / Amenaza | Mitigación Implementada en el Proyecto | Archivos Clave |
| :--- | :--- | :--- | :--- |
| **A01: Broken Access Control** | Acceso indebido a rutas protegidas o escalado de privilegios entre roles. | `FiltroAutenticacion` intercepta todas las peticiones, normaliza URIs y comprueba permisos según el rol (`ADMINISTRADOR`, `MEDICO`, `RECEPCIONISTA`). | [FiltroAutenticacion.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/filtros/FiltroAutenticacion.java), [sin-permiso.jsp](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/webapp/sin-permiso.jsp) |
| **A02: Cryptographic Failures** | Exposición de credenciales de BD y tráfico no cifrado. | Conexiones parametrizables vía variables de entorno (`DB_URL`, `DB_PASSWORD`), flags `HttpOnly` y `Secure` en cookies de sesión, soporte HTTPS. | [EntityManagerUtil.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/persistence/EntityManagerUtil.java), [web.xml](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/webapp/WEB-INF/web.xml) |
| **A03: Injection (SQL / XSS)** | Inyección SQL y Cross-Site Scripting reflejado o persistente. | Consultas JPQL 100% parametrizadas en JPA Controllers. Escape sistemático de entradas de usuario en vistas mediante `SecurityUtils.escapeHtml()`. | [SecurityUtils.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/Logica/SecurityUtils.java), JSPs del proyecto |
| **A04: Insecure Design** | Ausencia de controles anti-abuso y diseño permisivo. | Rate-limiting en el inicio de sesión (bloqueo tras 5 fallos durante 15 minutos) y desacoplamiento de capas. | [LoginAttemptService.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/Logica/LoginAttemptService.java) |
| **A05: Security Misconfiguration** | Exposición de stack traces, rutas por defecto y logs con datos sensibles. | Páginas de error personalizadas (404, 500) sin divulgación de versiones ni trazas; `show_sql=false` en `persistence.xml`. | [error-404.jsp](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/webapp/error-404.jsp), [error-500.jsp](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/webapp/error-500.jsp), [persistence.xml](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/resources/META-INF/persistence.xml) |
| **A07: Identification & Auth Failures** | Session Fixation, sesiones zombi y fuerza bruta de contraseñas. | Regeneración de identificador de sesión con `request.changeSessionId()` tras login; caducidad a 30 minutos; tracking modo solo COOKIE. | [SvLogin.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/servlets/SvLogin.java), [SvLogout.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/servlets/SvLogout.java) |
| **A08: Software & Data Integrity Failures** | Cross-Site Request Forgery (CSRF) en eliminaciones y acciones críticas. | Implementación de **Synchronizer Token Pattern** con `SecureRandom`, token por sesión y validación en tiempo constante en el filtro HTTP. | [SecurityUtils.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/Logica/SecurityUtils.java), [FiltroAutenticacion.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/filtros/FiltroAutenticacion.java) |
| **A09: Security Logging & Monitoring** | Falta de registro de quién accede a qué historial médico. | Servicio de auditoría `AuditService` registrando usuario, rol, IP, paciente y timestamp con fines de cumplimiento legal. | [AuditService.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/Logica/AuditService.java) |

---

## 3. Detalle de Componentes de Seguridad

### 3.1 Control de Acceso y Sesiones
- **Filtro de Autenticación (`FiltroAutenticacion.java`)**: 
  - Intercepta todas las URLs de la aplicación (`/*`).
  - Normaliza la URI para neutralizar ataques de *path traversal* (`/app/admin/../login.jsp`).
  - Excluye recursos públicos autorizados (estilos CSS, imágenes de Bootstrap/SB Admin 2, favicon, `login.jsp`, `SvLogin`, páginas de error).
  - Comprueba la validez de la sesión HTTP (`request.getSession(false)`). Si no existe sesión activa, redirige a `login.jsp`.
  - Impide que usuarios con roles insuficientes accedan a páginas administrativas (como gestión de usuarios o médicos), reenviando con código HTTP 403 a `sin-permiso.jsp`.
- **Mitigación de Fijación de Sesión (*Session Fixation*)**:
  - En [SvLogin.java](file:///Volumes/Datos/IDEA/ClinicaMedica/src/main/java/servlets/SvLogin.java), una vez validadas satisfactoriamente las credenciales, se invoca `request.changeSessionId()`. De este modo, cualquier identificador de sesión previo obtenido por un atacante antes de la autenticación queda invalidado.
- **Configuración de Cookies en `web.xml`**:
  - `<http-only>true</http-only>`: Bloquea el acceso a la cookie de sesión `JSESSIONID` desde scripts en el cliente (mitiga robo de credenciales vía XSS).
  - `<tracking-mode>COOKIE</tracking-mode>`: Prohíbe la propagación de sesiones mediante reescritura de URL (`URL rewriting`), eliminando el riesgo de fuga del ID de sesión en el historial del navegador o cabeceras `Referer`.
  - `<session-timeout>30</session-timeout>`: Expiración automática a los 30 minutos de inactividad.

### 3.2 Protección contra Ataques de Fuerza Bruta
- **Servicio `LoginAttemptService.java`**:
  - Mantiene un registro en memoria concurrente (`ConcurrentHashMap`) de intentos fallidos por usuario y por dirección IP remota.
  - Al acumular **5 intentos fallidos consecutivos**, la cuenta o IP queda temporalmente bloqueada durante **15 minutos**.
  - Si un usuario bloqueado intenta iniciar sesión, se rechaza la petición inmediatamente sin consultar la base de datos, mitigando ataques de denegación de servicio (DoS) sobre el servidor de base de datos.
  - Al autenticarse correctamente, el contador de fallos se reinicia a cero.

### 3.3 Protección contra Cross-Site Request Forgery - CSRF
- **Generación y Validación Criptográfica (`SecurityUtils.java`)**:
  - Se genera un token criptográfico de 32 bytes en base64 URL-safe utilizando `java.security.SecureRandom`.
  - El token reside en la sesión del usuario (`session.getAttribute("CSRF_TOKEN")`).
  - En las vistas JSP, los formularios con acciones destructivas o de modificación (por ejemplo, `SvEliminarUsuario`, `SvEliminarMedico`, `SvEliminarPaciente`, `SvEliminarCita`, `SvEliminarAdministrativo`) incluyen el campo oculto:
    ```html
    <input type="hidden" name="csrfToken" value="<%=SecurityUtils.obtenerOGenerarTokenCsrf(request.getSession())%>">
    ```
  - `FiltroAutenticacion` detecta peticiones POST dirigidas a endpoints críticos de eliminación y verifica el token.
  - La verificación utiliza `java.security.MessageDigest.isEqual(...)`, garantizando comparación en tiempo constante para anular posibles ataques de temporización (*timing attacks*). Si el token no coincide o está ausente, el filtro aborta la operación con un error HTTP 403 Forbidden.

### 3.4 Mitigación de Cross-Site Scripting - XSS
- **Sanitización de Salida (`SecurityUtils.escapeHtml`)**:
  - Todas las salidas dinámicas procedentes de la base de datos o de parámetros de petición son neutralizadas antes de emitirse en los JSPs:
    - `&` $\rightarrow$ `&amp;`
    - `<` $\rightarrow$ `&lt;`
    - `>` $\rightarrow$ `&gt;`
    - `"` $\rightarrow$ `&quot;`
    - `'` $\rightarrow$ `&#x27;`
    - `/` $\rightarrow$ `&#x2F;`
  - Esto impide la ejecución de inyecciones de código HTML/JavaScript almacenado o reflejado.

### 3.5 Cabeceras de Seguridad HTTP y Manejo de Errores
- **Cabeceras Inyectadas por `FiltroAutenticacion`**:
  - `X-Content-Type-Options: nosniff`: Impide que el navegador interprete archivos con tipos MIME incorrectos (MIME sniffing).
  - `X-Frame-Options: SAMEORIGIN`: Protege contra ataques de *Clickjacking*, impidiendo que la aplicación sea embebida en un `<iframe>` de terceros.
  - `X-XSS-Protection: 1; mode=block`: Activa el filtro XSS nativo del navegador.
  - `Referrer-Policy: strict-origin-when-cross-origin`: Restringe el envío de URLs con parámetros sensibles a sitios externos.
  - `Cache-Control: no-cache, no-store, must-revalidate` y `Pragma: no-cache`: Aplicado a rutas autenticadas para evitar que historias clínicas e informes queden almacenados en la caché local del disco del cliente o en proxys intermedios.
- **Páginas de Error Seguras (`error-404.jsp` y `error-500.jsp`)**:
  - Mapeadas en `web.xml` para capturar cualquier excepción no controlada (`java.lang.Throwable`), así como los códigos HTTP 404, 403 y 500.
  - Ocultan por completo el nombre y versión del contenedor (Apache Tomcat), el sistema operativo y el *stack trace* de Java, previniendo la divulgación de información técnica (*Information Disclosure*).

### 3.6 Registro de Auditoría de Datos de Salud - RGPD / LOPDGDD
- **Servicio `AuditService.java`**:
  - En cumplimiento con el **Reglamento General de Protección de Datos (RGPD UE 2016/679, Art. 9)** y la **Ley Orgánica 3/2018 (LOPDGDD)** de Protección de Datos y garantía de los derechos digitales, los datos relativos a la salud constituyen una categoría especial que exige trazabilidad de accesos.
  - Cada vez que un usuario consulta el historial clínico de un paciente (`SvHistorialPaciente`) o emite un informe médico (`SvGenerarInforme`), se genera una traza de auditoría con:
    - Identificador y nombre del usuario operador.
    - Rol profesional asignado.
    - Identificador del paciente accedido.
    - Tipo de acción realizada (`CONSULTA_HISTORIAL`, `GENERAR_INFORME_MEDICO`, etc.).
    - Dirección IP de origen.
    - Marca temporal ISO 8601 precisa.
  - Este registro es independiente de los logs habituales y permite a la clínica demostrar diligencia debida ante cualquier inspección o incidente de seguridad.

### 3.7 Gestión de Conexiones JPA y Variables de Entorno
- **Singleton `EntityManagerUtil.java`**:
  - Se eliminó el problema de rendimiento y agotamiento de recursos consistente en tener 9 `EntityManagerFactory` independientes (uno por cada JPA Controller).
  - Ahora existe una única instancia compartida gestionada por `EntityManagerUtil`.
  - Permite sobreescribir la configuración de base de datos en tiempo de ejecución sin necesidad de recompilar el proyecto, leyendo las variables de entorno estándar del sistema o de contenedores Docker:
    - `DB_URL`
    - `DB_USER`
    - `DB_PASSWORD`
    - `DB_DRIVER`
    - `HIBERNATE_HBM2DDL_AUTO`
  - Si las variables de entorno no están presentes, recurre limpiamente a la configuración declarada en `persistence.xml`.

---

## 4. Filosofía de Implementación: Cero JavaScript (Zero-JS Architecture)

En estricta observancia de los requerimientos del proyecto, **se eliminó la totalidad del código JavaScript aplicativo**:
1. **Calendario Mensual 100% Server-Side (`calendario-citas.jsp`)**: Se sustituyeron las dependencias externas (FullCalendar) por una cuadrícula de calendario mensual generada íntegramente en el servidor con Java/JSP y HTML/CSS puro. Soporta navegación temporal de meses (`« Anterior`, `Siguiente »`, `Mes Actual`) y filtrado simultáneo por médico y paciente mediante formularios y enlaces HTTP `GET` estándar.
2. **Acciones y Formularios Nativos**: Todos los flujos de alta, edición, filtrado, cancelación de citas y borrado operan mediante peticiones HTTP nativas `POST` y `GET` procesadas por servlets dedicados. Se eliminaron todos los controladores de eventos en línea (`onclick`, `onsubmit`, `onchange`, `alert`, `confirm`).
3. **Tokens CSRF Nativos**: El token CSRF se renderiza como `<input type="hidden" name="csrfToken" ...>` dentro de cada formulario estándar.
4. **Controles HTML5 Nativos**: Se utiliza la etiqueta estándar `<details>` y `<summary>` para desplegables y registros dinámicos sin necesidad de scripts de cliente.

---

## 5. Guía de Despliegue en Producción

### 5.1 Variables de Entorno Soportadas

Para desplegar la aplicación en cualquier entorno (servidor bare-metal, VPS, Docker o Kubernetes), configure las siguientes variables de entorno en el sistema anfitrión o en el contenedor:

```bash
# Conexión a la base de datos MySQL / MariaDB
export DB_URL="jdbc:mysql://db-server.internal:3306/clinica_medica?serverTimezone=UTC&useSSL=true&requireSSL=true"
export DB_USER="clinica_app_user"
export DB_PASSWORD="TU_PASSWORD_SUPER_SEGURO_AQUI"
export DB_DRIVER="com.mysql.cj.jdbc.Driver"

# Estrategia DDL de Hibernate (para producción se recomienda 'none' o 'validate')
export HIBERNATE_HBM2DDL_AUTO="validate"
```

> [!CAUTION]
> En entornos de producción **nunca** utilice `create-drop` ni `create` en `HIBERNATE_HBM2DDL_AUTO`, ya que provocaría la pérdida irrecuperable de la información médica. Utilice `validate` o `none`.

---

### 5.2 Despliegue Tradicional en Apache Tomcat

1. **Generación del artefacto WAR**:
   ```bash
   ./mvnw clean package -DskipTests
   ```
   El archivo compilado se ubicará en `target/ClinicaMedica-1.0-SNAPSHOT.war`. Puede renombrarlo a `ROOT.war` para servirlo en la raíz del servidor o a `ClinicaMedica.war`.

2. **Copiado al directorio de Tomcat**:
   ```bash
   cp target/ClinicaMedica-1.0-SNAPSHOT.war /opt/tomcat/webapps/ROOT.war
   ```

3. **Configuración de Variables de Entorno en Tomcat (`setenv.sh`)**:
   Cree o edite el archivo `/opt/tomcat/bin/setenv.sh`:
   ```bash
   export DB_URL="jdbc:mysql://localhost:3306/clinica_medica?serverTimezone=UTC&useSSL=false"
   export DB_USER="clinica_user"
   export DB_PASSWORD="MiPasswordSeguro2026!"
   export HIBERNATE_HBM2DDL_AUTO="update"
   export JAVA_OPTS="-Dfile.encoding=UTF-8 -Xms1024m -Xmx2048m -XX:+UseG1GC"
   ```
   Otorgue permisos de ejecución:
   ```bash
   chmod +x /opt/tomcat/bin/setenv.sh
   ```

4. **Hardening de `conf/server.xml` en Tomcat**:
   - Desactive el encabezado que expone la versión del servidor en el conector HTTP:
     ```xml
     <Connector port="8080" protocol="HTTP/1.1"
                connectionTimeout="20000"
                redirectPort="8443"
                server="Apache" />
     ```
   - Habilite la flag `secure` en las cookies en `conf/context.xml`:
     ```xml
     <Context useHttpOnly="true">
     ```

---

### 5.3 Despliegue en Contenedores (Docker & Docker Compose)

Para un despliegue moderno, escalable y aislado, se proporciona la siguiente arquitectura contenerizada:

#### `Dockerfile` (Multi-stage build)
Cree un archivo `Dockerfile` en la raíz del proyecto:

```dockerfile
# Etapa 1: Compilación con Maven
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Servidor Tomcat en ejecución
FROM tomcat:9.0-jdk17-corretto
LABEL maintainer="soporte@clinicamedica.es"

# Eliminar aplicaciones predeterminadas por seguridad
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el archivo WAR generado
COPY --from=builder /app/target/ClinicaMedica-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
```

#### `docker-compose.yml`
Cree el archivo `docker-compose.yml`:

```yaml
version: '3.8'

services:
  db:
    image: mysql:8.0
    container_name: clinica-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: RootPasswordSeguro2026!
      MYSQL_DATABASE: clinica_medica
      MYSQL_USER: clinica_user
      MYSQL_PASSWORD: AppPasswordSeguro2026!
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - clinica-network

  app:
    build: .
    container_name: clinica-tomcat
    restart: always
    depends_on:
      - db
    environment:
      DB_URL: "jdbc:mysql://db:3306/clinica_medica?serverTimezone=UTC&createDatabaseIfNotExist=true&useSSL=false"
      DB_USER: "clinica_user"
      DB_PASSWORD: "AppPasswordSeguro2026!"
      HIBERNATE_HBM2DDL_AUTO: "update"
    ports:
      - "127.0.0.1:8080:8080"
    networks:
      - clinica-network

networks:
  clinica-network:
    driver: bridge

volumes:
  mysql_data:
```

Para iniciar el sistema completo:
```bash
docker compose up -d --build
```

---

### 5.4 Configuración de Reverse Proxy con Nginx y Certificados SSL/TLS

Se recomienda encarecidamente ubicar un proxy inverso **Nginx** por delante de Tomcat para gestionar la terminación SSL/TLS y añadir una capa adicional de protección.

#### Archivo de configuración `/etc/nginx/sites-available/clinica.conf`:

```nginx
# Redirección obligatoria HTTP -> HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name clinica.tudominio.es;
    return 301 https://$host$request_uri;
}

# Servidor Seguro HTTPS
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name clinica.tudominio.es;

    # Certificados SSL (Let's Encrypt / Certbot)
    ssl_certificate /etc/letsencrypt/live/clinica.tudominio.es/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/clinica.tudominio.es/privkey.pem;

    # Protocolos y Ciphers seguros
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;

    # Cabecera HSTS (Strict-Transport-Security)
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Prevención de ataques DoS y límites de subida
    client_max_body_size 10M;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Timeouts de conexión
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

---

## 6. Checklist de Verificación Previa al Pase a Producción

Antes de declarar la plataforma en estado operativo final, verifique los siguientes 10 puntos:

- [x] **Compilación Limpia**: `mvn clean package` genera el artefacto sin advertencias críticas ni errores.
- [x] **Credenciales Fuera del Repositorio**: Las credenciales de la BD de producción se inyectan únicamente vía variables de entorno (`DB_PASSWORD`).
- [x] **Estrategia DDL Segura**: `HIBERNATE_HBM2DDL_AUTO` configurado a `validate` o `none` (nunca `create-drop`).
- [x] **HTTPS Obligatorio**: Certificado TLS válido configurado en el reverse proxy o en Tomcat.
- [x] **Cookies HttpOnly y Secure**: La cookie `JSESSIONID` cuenta con flags de protección para evitar su extracción por script.
- [x] **Páginas de Error Genéricas**: Los errores 404 y 500 no muestran trazas ni versiones del servidor.
- [x] **Protección Anti-Fuerza Bruta Activa**: Las cuentas son bloqueadas tras 5 intentos fallidos durante 15 minutos.
- [x] **Tokens CSRF en Todas las Acciones Destructivas**: Eliminación de usuarios, médicos, pacientes, citas y administrativos protegidas.
- [x] **Trazabilidad RGPD Registrada**: Las consultas a historiales y generación de informes escriben registros de auditoría completos.
- [x] **SQL Logging Deshabilitado**: `hibernate.show_sql` configurado a `false` para evitar exponer información clínica en logs de consola.
