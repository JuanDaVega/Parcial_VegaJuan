<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuario = "postgres";
    String contrasena = "123";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int idAnteproyecto = 0;
    String titulo = "";
    String alumno = "";
    String estado = "";
    String mensaje = "";

    try {
        if (request.getParameter("id_anteproyecto") != null) {
            idAnteproyecto = Integer.parseInt(request.getParameter("id_anteproyecto"));
        }

        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection(url, usuario, contrasena);

        // Obtener título del anteproyecto
        String tituloQuery = "SELECT titulo FROM anteproyecto WHERE id = ?";
        ps = con.prepareStatement(tituloQuery);
        ps.setInt(1, idAnteproyecto);
        rs = ps.executeQuery();
        if (rs.next()) {
            titulo = rs.getString("titulo");
        }
        rs.close();
        ps.close();

        // Obtener archivo y estado del alumno
        String sql = "SELECT archivo_ruta, estado FROM informe_anteproyecto " +
                     "WHERE id_anteproyecto = ? AND tipo_usuario = 'alumno' " +
                     "ORDER BY fecha_subida DESC LIMIT 1";
        ps = con.prepareStatement(sql);
        ps.setInt(1, idAnteproyecto);
        rs = ps.executeQuery();
        if (rs.next()) {
            alumno = rs.getString("archivo_ruta");
            estado = rs.getString("estado");
        }

        // Obtener ID del director desde sesión y convertirlo a String
        Object idDirectorObj = session.getAttribute("id_director");
        String idDirectorStr = (idDirectorObj != null) ? idDirectorObj.toString() : "";

        // Verificar si se ha enviado una acción (calificación)
        String accion = request.getParameter("accion");
        if (accion != null) {
            String updateSQL = "UPDATE informe_anteproyecto SET estado = ? " +
                               "WHERE id_anteproyecto = ? AND tipo_usuario = 'director'";
            ps = con.prepareStatement(updateSQL);
            ps.setString(1, accion);
            ps.setInt(2, idAnteproyecto);
            int rowsUpdated = ps.executeUpdate();

            // Si la actualización fue exitosa
            if (rowsUpdated > 0) {
                mensaje = "El estado del anteproyecto fue actualizado a: " + accion;
            } else {
                mensaje = "Error al actualizar el estado del anteproyecto.";
            }
        }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Calificar Anteproyecto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
            padding: 30px;
        }
        h2 {
            font-weight: 700;
            color: #1A0DAB;
            font-size: 2.5rem;
            text-align: center;
        }
        .table th {
            background-color: #1A0DAB;
            color: #fff;
        }
        .table td {
            background-color: #fff;
            text-align: center;
        }
    </style>
</head>
<body>

    <%
    if (mensaje != null && !mensaje.isEmpty()) {
%>
    <div class="alert alert-success text-center">
        <strong><%= mensaje %></strong>
    </div>
<%
    }
%>
<div class="container">
    <h2>Calificar Anteproyecto</h2>
    <div class="text-center mb-4">
        <p><strong>ID Anteproyecto:</strong> <%= idAnteproyecto %></p>
        <p><strong>Título:</strong> <%= titulo %></p>
        <p><strong>Alumno:</strong> <%= (alumno != null && !alumno.isEmpty()) ? alumno : "Enviado" %></p>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>Rol</th>
                <th>Archivo</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>Alumno</td>
                <td>
                    <% if (alumno != null && !alumno.isEmpty()) { %>
                        <a href="<%= alumno %>" target="_blank" class="btn btn-outline-primary btn-sm">Ver archivo</a>
                    <% } else { %>
                        <span class="text-muted">Enviado</span>
                    <% } %>
                </td>
                <td><%= (estado != null && !estado.isEmpty()) ? estado : "Enviado" %></td>
                <td>
                    <% if (alumno != null && !alumno.isEmpty()) { %>
                        <form method="post" action="calificar_anteproyecto.jsp" class="d-inline">
                            <input type="hidden" name="id_anteproyecto" value="<%= idAnteproyecto %>">
                            <input type="hidden" name="id_usuario" value="<%= idDirectorStr %>">
                            <input type="hidden" name="rol" value="director">
                            <input type="hidden" name="accion" value="APROBADO">
                            <button type="submit" class="btn btn-outline-success btn-sm">Aprobar</button>
                        </form>

                        <form method="post" action="calificar_anteproyecto.jsp" class="d-inline">
                            <input type="hidden" name="id_anteproyecto" value="<%= idAnteproyecto %>">
                            <input type="hidden" name="id_usuario" value="<%= idDirectorStr %>">
                            <input type="hidden" name="rol" value="director">
                            <input type="hidden" name="accion" value="RECHAZADO">
                            <button type="submit" class="btn btn-outline-danger btn-sm">Rechazar</button>
                        </form>

                        <form method="post" action="calificar_anteproyecto.jsp" class="d-inline">
                            <input type="hidden" name="id_anteproyecto" value="<%= idAnteproyecto %>">
                            <input type="hidden" name="id_usuario" value="<%= idDirectorStr %>">
                            <input type="hidden" name="rol" value="director">
                            <input type="hidden" name="accion" value="CORREGIDO">
                            <button type="submit" class="btn btn-outline-warning btn-sm">Corregir</button>
                        </form>
                    <% } else { %>
                        <span class="text-muted">Sin acciones</span>
                    <% } %>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="text-center mt-4">
        <a href="director.jsp" class="btn btn-outline-dark">Volver</a>
    </div>

<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }
%>
</div>
</body>
</html>
