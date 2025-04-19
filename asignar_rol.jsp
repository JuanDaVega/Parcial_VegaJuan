<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int anteproyectoId = Integer.parseInt(request.getParameter("anteproyecto_id"));
    Integer directorId = request.getParameter("director") != null ? Integer.parseInt(request.getParameter("director")) : null;
    Integer evaluadorId = request.getParameter("evaluador") != null ? Integer.parseInt(request.getParameter("evaluador")) : null;

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        if (directorId != null) {
            // Asignar director si no está asignado
            String sqlDirector = "UPDATE anteproyecto SET id_director = ? WHERE id = ? AND id_director IS NULL";
            stmt = conn.prepareStatement(sqlDirector);
            stmt.setInt(1, directorId);
            stmt.setInt(2, anteproyectoId);
            stmt.executeUpdate();
        }

        if (evaluadorId != null) {
            // Asignar evaluador si no está asignado
            String sqlEvaluador = "UPDATE anteproyecto SET id_evaluador = ? WHERE id = ? AND id_evaluador IS NULL";
            stmt = conn.prepareStatement(sqlEvaluador);
            stmt.setInt(1, evaluadorId);
            stmt.setInt(2, anteproyectoId);
            stmt.executeUpdate();
        }

        response.sendRedirect("asignar.jsp?id=" + anteproyectoId);
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
