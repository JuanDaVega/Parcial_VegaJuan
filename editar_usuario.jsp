<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    String rol = request.getParameter("rol");
    String idStr = request.getParameter("id");
    int id = (idStr != null) ? Integer.parseInt(idStr) : -1;

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String nombre = request.getParameter("nombre");
            String correo = request.getParameter("correo");
            String contrasena = request.getParameter("contrasena");

            // Si la contraseña está vacía, mantener la anterior
            if (contrasena == null || contrasena.isEmpty()) {
                // Recuperar la contraseña anterior de la base de datos (en caso de que no se proporcione una nueva)
                contrasena = rs.getString("contrasena");
            }

            String nuevoRol = request.getParameter("nuevoRol");

            if (nuevoRol != null && !rol.equals(nuevoRol)) {
                // Si el rol cambió, mover el usuario a la nueva tabla

                // Insertar en la nueva tabla (según el nuevo rol) sin ID, ya que se genera automáticamente
                String insertSQL = "INSERT INTO " + nuevoRol + " (nombre, correo, contrasena) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(insertSQL);
                stmt.setString(1, nombre);
                stmt.setString(2, correo);
                stmt.setString(3, contrasena);
                stmt.executeUpdate();
                stmt.close();

                // Eliminar de la tabla anterior (rol antiguo)
                String deleteSQL = "DELETE FROM " + rol + " WHERE id = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, id);
                stmt.executeUpdate();
                stmt.close();

                // Redireccionar a la nueva lista
                response.sendRedirect("lista.jsp?rol=" + nuevoRol + "&mensaje=Usuario movido correctamente");
            } else {
                // Si el rol no cambió, solo actualizar datos
                String updateSQL = "UPDATE " + rol + " SET nombre = ?, correo = ?, contrasena = ? WHERE id = ?";
                stmt = conn.prepareStatement(updateSQL);
                stmt.setString(1, nombre);
                stmt.setString(2, correo);
                stmt.setString(3, contrasena);
                stmt.setInt(4, id);
                stmt.executeUpdate();
                stmt.close();

                response.sendRedirect("lista.jsp?rol=" + rol + "&mensaje=Usuario actualizado correctamente");
            }
        } else {
            // Mostrar formulario de edición
            String selectSQL = "SELECT nombre, correo, contrasena FROM " + rol + " WHERE id = ?";
            stmt = conn.prepareStatement(selectSQL);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
%>
<html>
<head>
    <title>Editar Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4 text-center">Editar Usuario</h2>
    <form method="post" action="editar_usuario.jsp?rol=<%= rol %>&id=<%= id %>">
        <div class="mb-3">
            <label for="nombre" class="form-label">Nombre:</label>
            <input type="text" class="form-control" id="nombre" name="nombre" value="<%= rs.getString("nombre") %>" required>
        </div>
        <div class="mb-3">
            <label for="correo" class="form-label">Correo:</label>
            <input type="email" class="form-control" id="correo" name="correo" value="<%= rs.getString("correo") %>" required>
        </div>
        <div class="mb-3">
            <label for="contrasena" class="form-label">Contraseña:</label>
            <input type="password" class="form-control" id="contrasena" name="contrasena" value="<%= rs.getString("contrasena") %>" placeholder="Deje vacío para mantener la actual">
        </div>
        <div class="mb-3">
            <label for="nuevoRol" class="form-label">Rol:</label>
            <select class="form-select" id="nuevoRol" name="nuevoRol" required>
                <option value="">-- Seleccione un rol --</option>
                <option value="estudiante" <%= rol.equals("estudiante") ? "selected" : "" %>>Estudiante</option>
                <option value="director" <%= rol.equals("director") ? "selected" : "" %>>Director</option>
                <option value="evaluador" <%= rol.equals("evaluador") ? "selected" : "" %>>Evaluador</option>
                <option value="coordinador" <%= rol.equals("coordinador") ? "selected" : "" %>>Coordinador</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Actualizar</button>
        <a href="lista.jsp?rol=<%= rol %>" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
</body>
</html>

<%
            } else {
                out.println("<div class='alert alert-danger'>Usuario no encontrado.</div>");
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
