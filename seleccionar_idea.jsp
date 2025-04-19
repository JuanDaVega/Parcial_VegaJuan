<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    // Obtener el id del alumno desde la sesión
    Integer idAlumno = (Integer) session.getAttribute("id_alumno");

    // Declarar las variables antes del bloque try para que sean accesibles en finally
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (idAlumno == null) {
            // Si no hay id de alumno, redirigir a login
            response.sendRedirect("login.jsp");
            return;
        }

        con = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        // Consultar si el alumno ya tiene un anteproyecto asignado
        String sqlVerificacion = "SELECT id_alumno FROM anteproyecto WHERE id_alumno = ?";
        ps = con.prepareStatement(sqlVerificacion);
        ps.setInt(1, idAlumno);
        rs = ps.executeQuery();

        if (rs.next()) {
            // Si el alumno tiene un anteproyecto asignado, redirigir al panel del alumno
            response.sendRedirect("alumno.jsp");
            return;
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        // Asegurarse de cerrar las variables en el finally
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
            out.println("Error al cerrar los recursos: " + e.getMessage());
        }
    }
%>
<html>
<head>
    <title>Seleccionar Idea</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="style.css">
</head>

<style>
    body {
        background-color: #f0f2f5;
        font-family: 'Arial', sans-serif;
        color: #333;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 30px;
    }

    .header-container {
        position: relative;
        margin-bottom: 40px;
    }

    .logo-uts {
        position: absolute;
        top: 10px;
        left: 10px;
        width: 150px;
    }

    h2 {
        font-weight: 700;
        color: #1A0DAB;
        font-size: 2.5rem;
        text-align: center;
        margin-top: 20px;
    }

    .image-container {
        height: 200px;
        width: 100%;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .image-container img {
        height: 100%;
        width: auto;
        object-fit: cover;
    }

    .card {
        margin-top: 20px;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        background-color: #fff;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
    }

    .card-body {
        padding: 25px;
    }

    .card-title {
        font-weight: 700;
        color: #1A0DAB;
        font-size: 1.75rem;
    }

    .card-text {
        font-size: 1.1rem;
        color: #555;
    }

    .table {
        width: 100%;
        margin-top: 20px;
        border-collapse: collapse;
    }

    .table th, .table td {
        padding: 12px;
        text-align: center;
    }

    .table th {
        background-color: #1A0DAB;
        color: #fff;
    }

    .table td {
        background-color: #f9f9f9;
    }

    .table-hover tbody tr:hover {
        background-color: #f1f1f1;
    }

    .btn-role {
        width: 100%;
        font-weight: bold;
        border-radius: 10px;
        padding: 10px;
        text-align: center;
        transition: background-color 0.3s;
    }

    .btt-btn {
        background-color: #C3D730;
        color: #1A0DAB;
        border: none;
    }

    .btt-btn:hover {
        background-color: #0A8754;
    }

    .btt-btn:focus {
        outline: none;
        box-shadow: 0 0 10px rgba(0, 167, 90, 0.5);
    }

    .btn-outline-primary, .btn-outline-success, .btn-outline-warning {
        width: 100%;
        padding: 10px;
        font-weight: bold;
        border-radius: 10px;
        transition: background-color 0.3s;
    }

    .btn-outline-primary:hover {
        background-color: #007BFF;
        color: white;
    }

    .btn-outline-success:hover {
        background-color: #28A745;
        color: white;
    }

    .btn-outline-warning:hover {
        background-color: #FFC107;
        color: white;
    }

    .table-responsive {
        max-height: 400px;
        overflow-y: auto;
        margin-top: 20px;
    }

    .container {
        max-width: 1200px;
    }

    .admin-btn {
        background-color: #C3D730;
        color: #1A0DAB;
    }

    .admin-btn:hover {
        background-color: #0A8754;
    }

    @media (max-width: 768px) {
        .card-body {
            padding: 20px;
        }

        .card-title {
            font-size: 1.5rem;
        }

        .btn-role {
            font-size: 1rem;
        }
    }
</style>
<body class="bg-light">
<div class="container mt-5">
    <div class="header-container">
        <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
        <h2>SELECCIONAR IDEA DE PROYECTO</h2>
    </div>
<br>    <div class="table-responsive">
        <table class="table table-hover">
            <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>ESTADO</th>
                    <th>Seleccionar</th>
                </tr>
            </thead>
            <tbody>
            <%
                // Si el alumno no tiene asignado un anteproyecto, mostrar las ideas disponibles
                boolean hayIdeas = false; // Variable para verificar si hay ideas
                try {
                    con = DriverManager.getConnection(url, usuarioDB, contrasenaDB);
                    String sql = "SELECT * FROM anteproyecto WHERE id_alumno IS NULL";
                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int idAnte = rs.getInt("id");
                        String titulo = rs.getString("titulo");
                        String descripcion = rs.getString("descripcion");
                        String estado = rs.getString("estado");
                        hayIdeas = true; // Si encuentra ideas, cambia a true
            %>
                <tr>
                    <td><%= idAnte %></td>
                    <td><%= titulo %></td>
                    <td><%= descripcion %></td>
                    <td><%= estado %></td>
                    <td>
                        <form action="asignar_anteproyecto.jsp" method="post">
                            <input type="hidden" name="id_anteproyecto" value="<%= idAnte %>">
                            <input type="hidden" name="id_alumno" value="<%= idAlumno %>">
                            <button type="submit" class="btn btn-success btn-sm">Seleccionar</button>
                        </form>
                    </td>
                </tr>
            <%
                    }

                    // Si no hay ideas disponibles
                    if (!hayIdeas) {
            %>
                <tr>
                    <td colspan="5" class="text-center text-muted">No hay ideas disponibles para seleccionar en este momento.</td>
                </tr>
            <%
                    }

                } catch (Exception e) {
                    out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    // Asegurarse de cerrar las variables en el finally
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (con != null) con.close();
                    } catch (Exception e) {
                        out.println("Error al cerrar los recursos: " + e.getMessage());
                    }
                }
            %>
            </tbody>
        </table>
    </div>
    <div class="text-center mt-4">
        <a href="alumno.jsp" class="btn btn-outline-secondary">Volver al Panel</a>
    </div>
</div>
</body>
</html>
