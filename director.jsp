<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String mensaje = "";
    java.util.List<java.util.Map<String, Object>> anteproyectos = new java.util.ArrayList<>();
    
    // Obtener el id del director desde la sesión
    Integer idDirector = (Integer) session.getAttribute("id_director");
    
    if (idDirector == null) {
        mensaje = "No se encontró el director en la sesión.";
    } else {
        try {
            // Cargar el driver PostgreSQL
            Class.forName("org.postgresql.Driver");

            // Establecer conexión
            con = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

            // Consulta SQL para obtener los anteproyectos del director
            String sql = "SELECT a.id AS id_anteproyecto, a.titulo, al.nombre AS alumno_nombre, e.nombre AS evaluador_nombre " +
                         "FROM anteproyecto a " +
                         "LEFT JOIN alumno al ON a.id_alumno = al.id " +
                         "LEFT JOIN evaluador e ON a.id_evaluador = e.id " +
                         "WHERE a.id_director = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, idDirector);  // Usamos el id_director de la sesión
            rs = ps.executeQuery();

            // Recoger los resultados de la consulta
            while (rs.next()) {
                java.util.Map<String, Object> row = new java.util.HashMap<>();
                row.put("id", rs.getInt("id_anteproyecto"));
                row.put("titulo", rs.getString("titulo"));
                row.put("alumno", rs.getString("alumno_nombre") != null ? rs.getString("alumno_nombre") : "Sin asignar");
                row.put("evaluador", rs.getString("evaluador_nombre") != null ? rs.getString("evaluador_nombre") : "Sin asignar");
                anteproyectos.add(row);
            }

            mensaje = anteproyectos.isEmpty()
                      ? "No tienes anteproyectos asignados para calificar."
                      : "Tienes anteproyectos asignados para calificar.";

        } catch (Exception e) {
            mensaje = "Error: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
%>

<html>
<head>
    <title>Panel de Director</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            <h2>Panel Director</h2>
        </div>
<br><br>
        <div class="row g-4 mb-4">
            <div class="col-12">
                <div class="alert alert-info">
                    <%= mensaje %>
                </div>
            </div>

            <% if (!anteproyectos.isEmpty()) { %>
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-body">
                        <h4 class="card-title">Anteproyectos Asignados</h4>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Título</th>
                                    <th>Alumno</th>
                                    <th>Evaluador</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (java.util.Map<String, Object> row : anteproyectos) { %>
                                <tr>
                                    <td><%= row.get("titulo") %></td>
                                    <td><%= row.get("alumno") %></td>
                                    <td><%= row.get("evaluador") %></td>
                                    <td>
                                        <form action="calificar_anteproyecto.jsp" method="post" style="display:inline;">
                                            <input type="hidden" name="id_anteproyecto" value="<%= row.get("id") %>">
                                            <button type="submit" class="btn btn-warning btn-sm">Calificar</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <div class="row g-4">
        <div class="col-md-6 ">
            <div class="card shadow">
                <div class="card-body text-center">
                    <h4 class="card-title">Subir Anteproyecto</h4>
                    <p class="card-text">Crea y sube tu anteproyecto con la información del director y evaluador.</p>
                    <form action="subir_d.jsp" method="post">
                        <button type="submit" class="btn btn-role admin-btn">
                            Subir Anteproyecto
                        </button>
                    </form>
                </div>
            </div>
        </div>
    

       
            <div class="col-md-6 ">
                <div class="card shadow ">
                    <div class="card-body text-center">
                        <h4 class="card-title">Calendario Académico y formatos de grado</h4>
                        <p class="card-text">Consulta el calendario académico de la universidad.</p>
                        <form action="info.jsp" method="post">
                            <button type="submit" class="btn btn-role admin-btn">
                                Ver
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        
        </div>

        <div class="text-center mt-4">
            <a href="index.jsp" class="btn btn-outline-dark">Volver al Inicio</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
