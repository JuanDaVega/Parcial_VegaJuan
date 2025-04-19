<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    int anteproyectoId = Integer.parseInt(request.getParameter("id"));
    String correoDirector = null;
    String correoEvaluador = null;

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        // Consultar el anteproyecto y los correos de director y evaluador
        String sql = "SELECT u_director.correo AS correo_director, u_evaluador.correo AS correo_evaluador " +
                     "FROM anteproyecto a " +
                     "LEFT JOIN director u_director ON a.id_director = u_director.id " +
                     "LEFT JOIN evaluador u_evaluador ON a.id_evaluador = u_evaluador.id " +
                     "WHERE a.id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, anteproyectoId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            correoDirector = rs.getString("correo_director");
            correoEvaluador = rs.getString("correo_evaluador");
        }
%>

<html>
<head>
    <title>Asignar Roles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; }
        .form-group { margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h3 class="text-center">Asignar Roles al Anteproyecto</h3>
        <div class="card">
            <div class="card-body">
                <form method="post" action="asignar_rol.jsp">
                    <input type="hidden" name="anteproyecto_id" value="<%= anteproyectoId %>">
                    
                    <!-- Asignar Director -->
                    <% if (correoDirector == null) { %>
                        <div class="form-group">
                            <label for="director">Seleccionar Director</label>
                            <select class="form-control" id="director" name="director" required>
                                <%
                                    // Consultar directores disponibles
                                    String sqlDirectores = "SELECT id, correo FROM director WHERE id NOT IN (SELECT id_director FROM anteproyecto WHERE id_director IS NOT NULL)";
                                    stmt = conn.prepareStatement(sqlDirectores);
                                    rs = stmt.executeQuery();
                                    while (rs.next()) {
                                        int idDirector = rs.getInt("id");
                                        String correoDir = rs.getString("correo");
                                %>
                                        <option value="<%= idDirector %>"><%= correoDir %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success">Asignar Director</button>
                    <% } else { %>
                        <div class="alert alert-success">
                            Director asignado: <%= correoDirector %>
                        </div>
                    <% } %>

                    <hr>

                    <!-- Asignar Evaluador -->
                    <% if (correoEvaluador == null) { %>
                        <div class="form-group">
                            <label for="evaluador">Seleccionar Evaluador</label>
                            <select class="form-control" id="evaluador" name="evaluador" >
                                <%
                                    // Consultar evaluadores disponibles
                                    String sqlEvaluadores = "SELECT id, correo FROM evaluador WHERE id NOT IN (SELECT id_evaluador FROM anteproyecto WHERE id_evaluador IS NOT NULL)";
                                    stmt = conn.prepareStatement(sqlEvaluadores);
                                    rs = stmt.executeQuery();
                                    while (rs.next()) {
                                        int idEvaluador = rs.getInt("id");
                                        String correoEval = rs.getString("correo");
                                %>
                                        <option value="<%= idEvaluador %>"><%= correoEval %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success">Asignar Evaluador</button>
                    <% } else { %>
                        <div class="alert alert-success">
                            Evaluador asignado: <%= correoEvaluador %>
                        </div>
                    <% } %>

                </form>
            </div>
        </div>
        
        <div class="text-center mt-5">
            <a href="anteproyectos.jsp" class="btn btn-outline-success">Volver</a>
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
