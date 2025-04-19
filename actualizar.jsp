<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : -1;
    String titulo = "";
    String descripcion = "";
    String estado = "";
    int id_coordinador = 0;
    String id_alumno = "";
    String id_director = "";
    String id_evaluador = "";

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String updateSQL = "UPDATE anteproyecto SET titulo = ?, descripcion = ?, estado = ?, id_coordinador = ?, id_alumno = ?, id_director = ?, id_evaluador = ? WHERE id = ?";
            stmt = conn.prepareStatement(updateSQL);
            stmt.setString(1, request.getParameter("titulo"));
            stmt.setString(2, request.getParameter("descripcion"));
            stmt.setString(3, request.getParameter("estado"));
            stmt.setInt(4, Integer.parseInt(request.getParameter("id_coordinador")));
            stmt.setObject(5, request.getParameter("id_alumno").isEmpty() ? null : Integer.parseInt(request.getParameter("id_alumno")));
            stmt.setObject(6, request.getParameter("id_director").isEmpty() ? null : Integer.parseInt(request.getParameter("id_director")));
            stmt.setObject(7, request.getParameter("id_evaluador").isEmpty() ? null : Integer.parseInt(request.getParameter("id_evaluador")));
            stmt.setInt(8, id);
            stmt.executeUpdate();

            response.sendRedirect("crud_anteproyectos.jsp");
            return;
        }

        if (id != -1) {
            String sql = "SELECT * FROM anteproyecto WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                titulo = rs.getString("titulo");
                descripcion = rs.getString("descripcion");
                estado = rs.getString("estado");
                id_coordinador = rs.getInt("id_coordinador");
                id_alumno = rs.getString("id_alumno") != null ? rs.getString("id_alumno") : "";
                id_director = rs.getString("id_director") != null ? rs.getString("id_director") : "";
                id_evaluador = rs.getString("id_evaluador") != null ? rs.getString("id_evaluador") : "";
            }
        } else {
            out.println("<div class='alert alert-danger'>ID no válido</div>");
        }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Anteproyecto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f2f5;
        }

        .card {
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            padding: 30px;
            margin-top: 40px;
        }

        h2 {
            font-weight: 700;
            color: #1A0DAB;
        }

        .btn-custom {
            background-color: #C3D730;
            color: #1A0DAB;
            border: none;
        }

        .btn-custom:hover {
            background-color: #0A8754;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card mx-auto" style="max-width: 700px;">
            <h2 class="text-center mb-4">Editar Anteproyecto</h2>
            <form method="post">
                <div class="mb-3">
                    <label class="form-label">Título</label>
                    <input type="text" name="titulo" class="form-control" value="<%= titulo %>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Descripción</label>
                    <textarea name="descripcion" class="form-control" rows="4" required><%= descripcion %></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Estado</label>
                    <select name="estado" class="form-select">
                        <option value="Sin Gestionar" <%= estado.equals("Sin Gestionar") ? "selected" : "" %>>Sin Gestionar</option>
                        <option value="En Proceso" <%= estado.equals("En Proceso") ? "selected" : "" %>>En Proceso</option>
                        <option value="Finalizado" <%= estado.equals("Finalizado") ? "selected" : "" %>>Finalizado</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">ID Coordinador</label>
                    <input type="number" name="id_coordinador" class="form-control" value="<%= id_coordinador %>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">ID Alumno</label>
                    <input type="number" name="id_alumno" class="form-control" value="<%= id_alumno %>">
                </div>
                <div class="mb-3">
                    <label class="form-label">ID Director</label>
                    <input type="number" name="id_director" class="form-control" value="<%= id_director %>">
                </div>
                <div class="mb-3">
                    <label class="form-label">ID Evaluador</label>
                    <input type="number" name="id_evaluador" class="form-control" value="<%= id_evaluador %>">
                </div>
                <div class="d-flex justify-content-between">
                    <button type="submit" class="btn btn-custom">Guardar Cambios</button>
                    <a href="crud_anteproyectos.jsp" class="btn btn-secondary">Cancelar</a>
                </div>
            </form>
        </div>
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
