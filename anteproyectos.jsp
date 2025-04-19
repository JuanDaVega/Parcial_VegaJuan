<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    
    // Eliminar anteproyecto si se envió un formulario con método POST
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("eliminar_id") != null) {
        int idEliminar = Integer.parseInt(request.getParameter("eliminar_id"));
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

            String eliminarSQL = "DELETE FROM anteproyecto WHERE id = ?";
            stmt = conn.prepareStatement(eliminarSQL);
            stmt.setInt(1, idEliminar);
            stmt.executeUpdate();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error al eliminar: " + e.getMessage() + "</div>");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        }
    }

    // Luego continuamos con la consulta de anteproyectos normalmente


    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        // Consultar todos los anteproyectos con los correos de director, evaluador y alumno
        String sql = "SELECT a.id, a.titulo, a.descripcion, a.estado, " +
                     "u_alumno.correo AS correo_alumno, " +
                     "u_director.correo AS correo_director, " +
                     "u_evaluador.correo AS correo_evaluador " +
                     "FROM anteproyecto a " +
                     "LEFT JOIN alumno u_alumno ON a.id_alumno = u_alumno.id " +
                     "LEFT JOIN director u_director ON a.id_director = u_director.id " +
                     "LEFT JOIN evaluador u_evaluador ON a.id_evaluador = u_evaluador.id";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
%>

<html>
<head>
    <title>Panel de Coordinación</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
        .estado-pendiente { color: #dc3545; font-weight: bold; }
        .estado-asignado { color: #28a745; font-weight: bold; }

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
</head>
<body class="bg-light">
    <div class="container mt-5">

        <div class="header-container">
            <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
            <h2 class="text-center">ANTEPROYECTOS</h2>
        </div>
    <br>

        <div class="row mb-4">
            <div class="col-mb-2">
                <a href="coordinador.jsp" class="btn btn-primary mt-3">
                VOLVER</a>
            </div>
           
        </div>
    
       

        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card shadow">
                    <div class="card-body">
                        <h5 class="card-title text-center">Anteproyectos Registrados</h5>
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered align-middle">
                                <thead class="table-dark">
                                    <tr class="text-center">
                                        <th>ID</th>
                                        <th>Título</th>
                                        <th>Descripción</th>
                                        <th>Estado</th>
                                        <th>Alumno</th>
                                        <th>Director</th>
                                        <th>Evaluador</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    while (rs.next()) {
                                        int id = rs.getInt("id");
                                        String titulo = rs.getString("titulo");
                                        String descripcion = rs.getString("descripcion");
                                        String estado = rs.getString("estado");
                                        String correoAlumno = rs.getString("correo_alumno");
                                        String correoDirector = rs.getString("correo_director");
                                        String correoEvaluador = rs.getString("correo_evaluador");
                                %>
                                    <tr class="text-center">
                                        <td><%= id %></td>
                                        <td><%= titulo %></td>
                                        <td><%= descripcion %></td>
                                        <td><%= estado %></td>
                                        
                                        <td>
                                            <% if (correoAlumno == null) { %>
                                                <span class="estado-pendiente">Sin gestionar</span>
                                            <% } else { %>
                                                <span class="estado-asignado"><%= correoAlumno %></span>
                                            <% } %>
                                        </td>

                                        <td>
                                            <% if (correoDirector == null) { %>
                                                <span class="estado-pendiente">Sin gestionar</span>
                                            <% } else { %>
                                                <span class="estado-asignado"><%= correoDirector %></span>
                                            <% } %>
                                        </td>

                                        <td>
                                            <% if (correoEvaluador == null) { %>
                                                <span class="estado-pendiente">Sin gestionar</span>
                                            <% } else { %>
                                                <span class="estado-asignado"><%= correoEvaluador %></span>
                                            <% } %>
                                        </td>

                                        <td>
                                            <div class="d-flex justify-content-center gap-2">
                                                <% if (correoDirector == null || correoEvaluador == null) { %>
                                                    <a href="asignar.jsp?id=<%= id %>" class="btn btn-success btn-sm">Asignar</a>
                                                <% } else { %>
                                                    <button class="btn btn-secondary btn-sm" disabled>Completo</button>
                                                <% } %>
                                        
                                                <form method="post" onsubmit="return confirm('¿Estás seguro de que deseas eliminar este anteproyecto?');">
                                                    <input type="hidden" name="eliminar_id" value="<%= id %>">
                                                    <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                                </form>
                                            </div>
                                        </td>
                                        
                                    </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a href="crud_anteproyectos.jsp" class="btn btn-outline-success">CREAR ANTEPROYECTO</a>

    </div>
   
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
