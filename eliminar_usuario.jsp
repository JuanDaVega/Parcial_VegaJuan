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

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Procesar la eliminación
            String deleteSQL = "DELETE FROM " + rol + " WHERE id = ?";
            stmt = conn.prepareStatement(deleteSQL);
            stmt.setInt(1, id);

            int rowsDeleted = stmt.executeUpdate();

            if (rowsDeleted > 0) {
                response.sendRedirect("lista.jsp?rol=" + rol + "&mensaje=Usuario eliminado correctamente");
            } else {
                out.println("<div class='alert alert-danger'>Error: No se pudo eliminar el usuario.</div>");
            }
        } else {
%>
<html>
<head>
    <title>Eliminar Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4 text-center text-danger">¿Confirmar Eliminación?</h2>
    <form method="post" action="eliminar_usuario.jsp?rol=<%= rol %>&id=<%= id %>">
        <div class="alert alert-warning text-center">
            ¿Estás seguro que deseas eliminar este usuario?
        </div>
        <div class="text-center">
            <button type="submit" class="btn btn-danger">Sí, eliminar</button>
            <a href="lista.jsp?rol=<%= rol %>" class="btn btn-secondary">Cancelar</a>
        </div>
    </form>
</div>
</body>
</html>
<%
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
