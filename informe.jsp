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

        String sql = "SELECT a.id AS anteproyecto_id, a.titulo, " +
                     "MAX(CASE WHEN i.tipo_usuario = 'alumno' THEN i.archivo_ruta END) AS informe_alumno, " +
                     "MAX(CASE WHEN i.tipo_usuario = 'director' THEN i.archivo_ruta END) AS informe_director, " +
                     "MAX(CASE WHEN i.tipo_usuario = 'evaluador' THEN i.archivo_ruta END) AS informe_evaluador " +
                     "FROM anteproyecto a " +
                     "LEFT JOIN informe_anteproyecto i ON a.id = i.id_anteproyecto " +
                     "GROUP BY a.id, a.titulo " +
                     "ORDER BY a.id";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Informes de Anteproyectos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
   <link rel="stylesheet" href="style.css">
   <style>
        body {
            background-color: #f0f2f5;
            padding: 30px;
            font-family: 'Arial', sans-serif;
        }
        .container {
            max-width: 1200px;
            margin: auto;
        }
        h2 {
            font-weight: 700;
            color: #1A0DAB;
            font-size: 2.5rem;
            text-align: center;
            margin-bottom: 30px;
        }
        .table th {
            background-color: #1A0DAB;
            color: white;
        }
        .text-muted {
            font-style: italic;
            color: gray;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-container">
            <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
            <h2 class="text-center">ANTEPROYECTOS</h2>
        </div>
    <br>        <div class="table-responsive">
            <table class="table table-hover table-bordered align-middle">
                <thead>
                    <tr class="text-center">
                        <th>ID</th>
                        <th>Título</th>
                        <th>Informe Alumno</th>
                        <th>Informe Director</th>
                        <th>Informe Evaluador</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (rs.next()) {
                            int id = rs.getInt("anteproyecto_id");
                            String titulo = rs.getString("titulo");
                            String informeAlumno = rs.getString("informe_alumno");
                            String informeDirector = rs.getString("informe_director");
                            String informeEvaluador = rs.getString("informe_evaluador");
                    %>
                    <tr class="text-center">
                        <td><%= id %></td>
                        <td><%= titulo %></td>
                        <td>
                            <% if (informeAlumno != null) { %>
                                <a href="<%= informeAlumno %>" target="_blank">Ver Informe</a>
                            <% } else { %>
                                <span class="text-muted">No disponible</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (informeDirector != null) { %>
                                <a href="<%= informeDirector %>" target="_blank">Ver Informe</a>
                            <% } else { %>
                                <span class="text-muted">No disponible</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (informeEvaluador != null) { %>
                                <a href="<%= informeEvaluador %>" target="_blank">Ver Informe</a>
                            <% } else { %>
                                <span class="text-muted">No disponible</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <a href="coordinador.jsp" class="btn btn-primary mb-4">VOLVER</a>

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
