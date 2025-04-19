<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String url = "jdbc:postgresql://localhost:5432/universidad";
String usuarioDB = "postgres";
String contrasenaDB = "123";

// Obtener el id del alumno desde la sesión
Integer idAlumno = (Integer) session.getAttribute("id_alumno");
Integer idAnteproyecto = Integer.parseInt(request.getParameter("id_anteproyecto"));

Connection con = null;
PreparedStatement ps = null;

try {
    if (idAlumno != null) {
        // Establecer la conexión con la base de datos
        con = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        // Asignar el anteproyecto al alumno, actualizando el campo id_alumno en la tabla anteproyecto
        String sql = "UPDATE anteproyecto SET id_alumno = ?, estado = 'Asignado' WHERE id = ? AND id_alumno IS NULL";
        ps = con.prepareStatement(sql);
        ps.setInt(1, idAlumno);
        ps.setInt(2, idAnteproyecto);

        int filasAfectadas = ps.executeUpdate();

        if (filasAfectadas > 0) {
            // Si la actualización fue exitosa, redirigir al alumno a su panel
            response.sendRedirect("alumno.jsp");
        } else {
            // Si no se ha podido asignar la idea (por ejemplo, ya está asignada)
            out.println("<div class='alert alert-danger'>No se pudo asignar el anteproyecto. Puede que ya esté asignado a otro alumno.</div>");
        }
    } else {
        out.println("<div class='alert alert-danger'>No se encontró el ID del alumno. Por favor, inicia sesión nuevamente.</div>");
    }
} catch (Exception e) {
    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
} finally {
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (con != null) try { con.close(); } catch (Exception e) {}
}
%>
