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
    String estadoAlumno = "";
    String estadoDirector = "";
    String mensaje = "";
    boolean puedeEvaluar = false;

    try {
        if (request.getParameter("id_anteproyecto") != null) {
            idAnteproyecto = Integer.parseInt(request.getParameter("id_anteproyecto"));
        }

        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection(url, usuario, contrasena);

        // Obtener título
        ps = con.prepareStatement("SELECT titulo FROM anteproyecto WHERE id = ?");
        ps.setInt(1, idAnteproyecto);
        rs = ps.executeQuery();
        if (rs.next()) {
            titulo = rs.getString("titulo");
        }
        rs.close();
        ps.close();

        // Obtener informe del alumno
        ps = con.prepareStatement("SELECT archivo_ruta, estado FROM informe_anteproyecto WHERE id_anteproyecto = ? AND tipo_usuario = 'alumno' ORDER BY fecha_subida DESC LIMIT 1");
        ps.setInt(1, idAnteproyecto);
        rs = ps.executeQuery();
        if (rs.next()) {
            alumno = rs.getString("archivo_ruta");
            estadoAlumno = rs.getString("estado");
        }
        rs.close();
        ps.close();

        // Obtener estado del director
        ps = con.prepareStatement("SELECT estado FROM informe_anteproyecto WHERE id_anteproyecto = ? AND tipo_usuario = 'director' ORDER BY fecha_subida DESC LIMIT 1");
        ps.setInt(1, idAnteproyecto);
        rs = ps.executeQuery();
        if (rs.next()) {
            estadoDirector = rs.getString("estado");
        }
        rs.close();
        ps.close();

        // Lógica para permitir o no evaluar
        if ("APROBADO".equalsIgnoreCase(estadoDirector)) {
            puedeEvaluar = true;
        } else {
            mensaje = "El director no ha aprobado el informe del alumno. Por tanto, no puedes calificarlo aún.";
        }

        // Acción de evaluación
        String accion = request.getParameter("accion");
        if (accion != null && puedeEvaluar) {
            ps = con.prepareStatement("UPDATE informe_anteproyecto SET estado = ? WHERE id_anteproyecto = ? AND tipo_usuario = 'evaluador'");
            ps.setString(1, accion);
            ps.setInt(2, idAnteproyecto);
            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                mensaje = "El estado del anteproyecto fue actualizado a: <strong>" + accion + "</strong>";
            } else {
                mensaje = "⚠️ No se pudo actualizar el estado del anteproyecto.";
            }
            ps.close();
        }

        Object idEvaluadorObj = session.getAttribute("id_evaluador");
        String idEvaluadorStr = (idEvaluadorObj != null) ? idEvaluadorObj.toString() : "";
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

<% if (mensaje != null && !mensaje.isEmpty()) { %>
    <div class="alert <%= puedeEvaluar ? "alert-success" : "alert-warning" %> text-center">
        <strong><%= mensaje %></strong>
    </div>
<% } %>

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
                <td><%= (estadoAlumno != null && !estadoAlumno.isEmpty()) ? estadoAlumno : "Enviado" %></td>
                <td>
                    <% if (puedeEvaluar && alumno != null && !alumno.isEmpty()) { %>
                        <form method="post" action="califi_ev.jsp" class="d-inline">
                            <input type="hidden" name="id_anteproyecto" value="<%= idAnteproyecto %>">
                            <input type="hidden" name="id_usuario" value="<%= idEvaluadorStr %>">
                            <input type="hidden" name="rol" value="evaluador">
                            <input type="hidden" name="accion" value="APROBADO">
                            <button type="submit" class="btn btn-outline-success btn-sm">Aprobar</button>
                        </form>

                        <form method="post" action="califi_ev.jsp" class="d-inline">
                            <input type="hidden" name="id_anteproyecto" value="<%= idAnteproyecto %>">
                            <input type="hidden" name="id_usuario" value="<%= idEvaluadorStr %>">
                            <input type="hidden" name="rol" value="evaluador">
                            <input type="hidden" name="accion" value="RECHAZADO">
                            <button type="submit" class="btn btn-outline-danger btn-sm">Rechazar</button>
                        </form>

                        <form method="post" action="califi_ev.jsp" class="d-inline">
                            <input type="hidden" name="id_anteproyecto" value="<%= idAnteproyecto %>">
                            <input type="hidden" name="id_usuario" value="<%= idEvaluadorStr %>">
                            <input type="hidden" name="rol" value="evaluador">
                            <input type="hidden" name="accion" value="CORREGIDO">
                            <button type="submit" class="btn btn-outline-warning btn-sm">Corregir</button>
                        </form>
                    <% } else { %>
                        <span class="text-muted">Acción deshabilitada</span>
                    <% } %>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="text-center mt-4">
        <a href="evaluador.jsp" class="btn btn-outline-dark">Volver</a>
    </div>
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
</body>
</html>
