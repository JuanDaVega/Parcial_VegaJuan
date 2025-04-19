<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Información Adicional</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Arial', sans-serif;
            color: #333;
            padding: 30px;
        }

        .card {
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

        .card-title {
            font-weight: 700;
            color: #1A0DAB;
            font-size: 1.75rem;
        }

        .card-text {
            font-size: 1.1rem;
            color: #555;
        }

        .btn-role {
            width: 100%;
            font-weight: bold;
            border-radius: 10px;
            padding: 10px;
            transition: background-color 0.3s;
        }

        .admin-btn {
            background-color: #C3D730;
            color: #1A0DAB;
        }

        .admin-btn:hover {
            background-color: #0A8754;
            color: #fff;
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
<body>
    <div class="container mt-5">
        <div class="header-container">
            <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
            <h2 class="text-center">Panel Alumno</h2>
        </div>
<br>
        <div class="row g-4">
            <!-- Calendario Académico -->
            <div class="col-md-6">
                <div class="card">
                    <div class="image-container">
                        <img src="img/calendario.jpg" alt="Calendario Académico">
                    </div>
                    <div class="card-body text-center">
                        <h4 class="card-title">Calendario Académico</h4>
                        <p class="card-text">Consulta las fechas importantes del año académico.</p>
                        <a href="https://www.uts.edu.co/sitio/wp-content/uploads/2025/01/ACUERDO-03-001-MODIFICACION-CALENDARIO-ACADE-PRESENCIAL.pdf" 
                        target="_blank" 
                        class="btn btn-role admin-btn">
                        Ver Calendario
                     </a>
                                         </div>
                </div>
            </div>

            <!-- Formatos de Grado -->
            <div class="col-md-6">
                <div class="card">
                    <div class="image-container">
                        <img src="img/formatos.jpg" alt="Formatos de Grado">
                    </div>
                    <div class="card-body text-center">
                        <h4 class="card-title">Formatos de Grado</h4>
                        <p class="card-text">Accede a los documentos requeridos para tu proceso de grado.</p>
                        <a href="docs/F-DC-125  Informe final trabajo grado modalidad proyecto de investigación, desarrollo tecnológico, monografía, emprendimiento y seminario V2.docx.pdf" target="_blank" class="btn btn-role admin-btn">
                            Ver Formatos
                        </a>                    </div>
                </div>
            </div>
        </div>

        <!-- Botón Volver -->
        <div class="text-center mt-4">
            <a href="javascript:history.back()" class="btn btn-secondary">Volver</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
