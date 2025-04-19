<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sistema Universitario - Agregar Usuario</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

    <nav class="navbar navbar-dark bg-dark">
        <a class="navbar-brand" href="#">Sistema Universitario</a>
    </nav>

    <div class="container mt-4">
        <h2 class="text-center mb-4">Agregar Usuario</h2>

        <c:if test="${empty param.nombre}">
            <div class="card shadow-sm p-4">
                <form method="post">
                    <div class="form-group">
                        <label>Nombre</label>
                        <input type="text" name="nombre" class="form-control" required>
                    </div>
                
                    <div class="form-group">
                        <label>Correo</label>
                        <input type="email" name="correo" class="form-control" required>
                    </div>
                
                    <div class="form-group">
                        <label>Contrasena</label>
                        <input type="password" name="contrasena" class="form-control" required>
                    </div>
                
                    <div class="form-group">
                        <label>Rol</label>
                        <sql:query var="rsRoles" dataSource="${universidad}">
                            SELECT * FROM roles
                        </sql:query>
                        <select name="id_rol" class="form-control" required>
                            <option value="">-- Seleccione un rol --</option>
                            <c:forEach var="rol" items="${rsRoles.rows}">
                                <option value="${rol.id}">
                                    <c:out value="${rol.descripcion}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                
                    <div class="text-center">
                        <button type="submit" class="btn btn-success">Registrar</button>
                        <a href="administrador.jsp" class="btn btn-secondary">Cancelar</a>
                    </div>
                </form>
                
            </div>
        </c:if>

        <c:if test="${not empty param.nombre and not empty param.correo and not empty param.contrasena and not empty param.id_rol}">
    <sql:update var="result" dataSource="${universidad}">
        <c:choose>
            <c:when test="${param.id_rol == 1}">
                INSERT INTO administrador (nombre, correo, contrasena, id_rol)
                VALUES ('${param.nombre}', '${param.correo}', '${param.contrasena}', ${param.id_rol})
            </c:when>
            <c:when test="${param.id_rol == 2}">
                INSERT INTO evaluador (nombre, correo, contrasena, id_rol)
                VALUES ('${param.nombre}', '${param.correo}', '${param.contrasena}', ${param.id_rol})
            </c:when>
            <c:when test="${param.id_rol == 3}">
                INSERT INTO director (nombre, correo, contrasena, id_rol)
                VALUES ('${param.nombre}', '${param.correo}', '${param.contrasena}', ${param.id_rol})
            </c:when>
            <c:when test="${param.id_rol == 4}">
                INSERT INTO alumno (nombre, correo, contrasena, id_rol)
                VALUES ('${param.nombre}', '${param.correo}', '${param.contrasena}', ${param.id_rol})
            </c:when>
            <c:when test="${param.id_rol == 5}">
                INSERT INTO coordinador (nombre, correo, contrasena, id_rol)
                VALUES ('${param.nombre}', '${param.correo}', '${param.contrasena}', ${param.id_rol})
            </c:when>
        </c:choose>
    </sql:update>

    <c:if test="${result >= 1}">
        <div class="alert alert-success text-center mt-4">
            Usuario registrado correctamente!
            <br>
            <a href="administrador.jsp" class="btn btn-primary mt-3">Regresar al inicio</a>
        </div>
    </c:if>

    <c:if test="${result == 0}">
        <div class="alert alert-danger text-center mt-4">
            Error al registrar el usuario.
            <br>
            <a href="registro_usuario.jsp" class="btn btn-danger mt-3">Intentar de nuevo</a>
        </div>
    </c:if>
</c:if>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
