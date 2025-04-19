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
    String mensaje = "";

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
            // Si el alumno tiene un anteproyecto asignado, mostrar mensaje
            mensaje = "Ya tienes una idea seleccionada.";
        } else {
            // Si no tiene un anteproyecto asignado, dar un mensaje alternativo
            mensaje = "Aún no has seleccionado una idea.";
        }

    } catch (Exception e) {
        mensaje = "Error al verificar el anteproyecto: " + e.getMessage();
    } finally {
        // Cerrar los recursos
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
            mensaje = "Error al cerrar los recursos: " + e.getMessage();
        }
    }
%>

<html>
<head>
    <title>Panel de Alumno</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="header-container">
            <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
            <h2>Panel Alumno</h2>
        </div>
<br><br>
        <!-- Mostrar el mensaje dependiendo del estado del anteproyecto -->
        <div class="alert alert-info text-center">
            <%= mensaje %>
        </div>

        <!-- Seleccionar Idea de Proyecto -->
        <br>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-body text-center">
                        <h4 class="card-title">Seleccionar Idea de Proyecto</h4>
                        <p class="card-text">Elige tu idea de proyecto para comenzar con el anteproyecto.</p>
                        <form action="seleccionar_idea.jsp" method="post">
                            <button type="submit" class="btn btn-role admin-btn">
                                Seleccionar Idea
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- CRUD para subir Anteproyectos -->
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-body text-center">
                        <h4 class="card-title">Subir Anteproyecto</h4>
                        <p class="card-text">Crea y sube tu anteproyecto con la información del director y evaluador.</p>
                        <form action="subir.jsp" method="post">
                            <button type="submit" class="btn btn-role admin-btn">
                                Subir Anteproyecto
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Informe de Calificación -->
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-body text-center">
                        <h4 class="card-title">Ver Calificación del Anteproyecto</h4>
                        <p class="card-text">Consulta las calificaciones de tu anteproyecto.</p>
                        <form action="calificaciones.jsp" method="post">
                            <button type="submit" class="btn btn-role admin-btn">
                                Ver Calificación
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6 offset-md-3">
                <div class="card shadow">
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

        <div class="text-center mt-5">
            <a href="index.jsp" class="btn btn-outline-success">Volver al Inicio</a>
        </div>
    </div> <!-- Cierre del contenedor -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
