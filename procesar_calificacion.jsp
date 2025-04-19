<%@ page import="java.sql.*" %>
<%
    int idAnteproyecto = Integer.parseInt(request.getParameter("id_anteproyecto"));
    String accion = request.getParameter("accion"); // Aprobado, Rechazado, Corregido
    String tipo_usuario = request.getParameter("rol"); // director
    int id_usuario = Integer.parseInt(request.getParameter("id_usuario")); // id del director

    // Verificar que 'accion' tiene un valor válido
    if (!(accion.equals("APROBADO") || accion.equals("RECHAZADO") || accion.equals("CORREGIDO"))) {
        out.println("<div class='alert alert-danger'>Acción no válida.</div>");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/universidad", "postgres", "123");

        // Insertar calificación como nuevo informe
        String sql = "INSERT INTO informe_anteproyecto (id_anteproyecto, tipo_usuario, archivo_ruta, estado, fecha_subida) " +
                     "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)";
        ps = con.prepareStatement(sql);
        ps.setInt(1, idAnteproyecto);
        ps.setString(2, tipo_usuario);
        ps.setString(3, ""); // archivo vacío
        ps.setString(4, accion); // Aprobado, Rechazado, Corregido
        ps.executeUpdate();

        response.sendRedirect("calificar_anteproyecto.jsp?id_anteproyecto=" + idAnteproyecto + "&mensaje=" + accion.toLowerCase());
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (con != null) con.close(); } catch (Exception ignored) {}
    }
%>
