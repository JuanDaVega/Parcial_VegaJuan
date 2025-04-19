<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        // Manejar eliminación si se envía
        String accion = request.getParameter("accion");
        if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String deleteSQL = "DELETE FROM anteproyecto WHERE id = ?";
            stmt = conn.prepareStatement(deleteSQL);
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }

        // Crear nuevo anteproyecto
        if ("crear".equals(accion)) {
            String sql = "INSERT INTO anteproyecto (titulo, descripcion, estado, id_coordinador, id_alumno, id_director, id_evaluador) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, request.getParameter("titulo"));
            stmt.setString(2, request.getParameter("descripcion"));
            stmt.setString(3, request.getParameter("estado"));
            stmt.setInt(4, Integer.parseInt(request.getParameter("id_coordinador")));
            stmt.setObject(5, request.getParameter("id_alumno").isEmpty() ? null : Integer.parseInt(request.getParameter("id_alumno")));
            stmt.setObject(6, request.getParameter("id_director").isEmpty() ? null : Integer.parseInt(request.getParameter("id_director")));
            stmt.setObject(7, request.getParameter("id_evaluador").isEmpty() ? null : Integer.parseInt(request.getParameter("id_evaluador")));
            stmt.executeUpdate();
        }

        // Obtener todos los anteproyectos
        String sql = "SELECT * FROM anteproyecto ORDER BY id DESC";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
%>

<html>
<head>
    <title>CRUD Anteproyectos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4 text-center">Gestión de Anteproyectos</h2>

        <!-- Formulario para crear nuevo anteproyecto -->
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">Registrar Anteproyecto</h5>
                <form method="post">
                    <input type="hidden" name="accion" value="crear">
                    <div class="row">
                        <div class="mb-3 col-md-6">
                            <label class="form-label">Título</label>
                            <input type="text" name="titulo" class="form-control" required>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label class="form-label">Estado</label>
                            <select name="estado" class="form-select">
                                <option value="Sin Gestionar">Sin Gestionar</option>
                                <option value="En Proceso">En Proceso</option>
                                <option value="Finalizado">Finalizado</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Descripción</label>
                        <textarea name="descripcion" class="form-control" required></textarea>
                    </div>
                    <div class="row">
                        <div class="mb-3 col-md-3">
                            <label class="form-label">ID Coordinador</label>
                            <input type="number" name="id_coordinador" class="form-control" required>
                        </div>
                        <div class="mb-3 col-md-3">
                            <label class="form-label">ID Alumno</label>
                            <input type="number" name="id_alumno" class="form-control">
                        </div>
                        <div class="mb-3 col-md-3">
                            <label class="form-label">ID Director</label>
                            <input type="number" name="id_director" class="form-control">
                        </div>
                        <div class="mb-3 col-md-3">
                            <label class="form-label">ID Evaluador</label>
                            <input type="number" name="id_evaluador" class="form-control">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success">Crear</button>
                </form>
            </div>
        </div>

        <!-- Tabla de anteproyectos -->
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Anteproyectos Registrados</h5>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr class="text-center">
                            <th>ID</th>
                            <th>Título</th>
                            <th>Estado</th>
                            <th>Coordinador</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% while (rs.next()) { %>
                            <tr class="text-center">
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("titulo") %></td>
                                <td><%= rs.getString("estado") %></td>
                                <td><%= rs.getInt("id_coordinador") %></td>
                                <td>
                                    <a href="actualizar.jsp?id=<%= rs.getInt("id") %>" class="btn btn-info btn-sm">Editar</a>
                                    <form method="post" style="display:inline;">
                                        <input type="hidden" name="accion" value="eliminar">
                                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de eliminar este anteproyecto?');">Eliminar</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <a href="anteproyectos.jsp" class="btn btn-outline-success">Volver</a>

    </div>
</body>
</html>

<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
