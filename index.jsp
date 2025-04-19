<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Roles</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
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
            top: 0;
            left: 0;
            width: 150px; 
        }
        h2 {
            font-weight: 800;
            color: #1A0DAB;
            font-size: 2.5rem;
            text-align: center;
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
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .btn-role {
            width: 100%;
            font-weight: bold;
            border-radius: 10px;
            transition: background-color 0.3s;
        }
        .admin-btn {
            background-color: #C3D730;
            color: #1A0DAB;
        }
        .admin-btn:hover {
            background-color: #0A8754;
        }
        .coordination-btn {
            background-color: #C3D730;
            color: #1A0DAB;
        }
        .coordination-btn:hover {
            background-color: #0A8754;
        }
        .student-btn {
            background-color: #C3D730;
            color: #1A0DAB;
        }
        .student-btn:hover {
            background-color: #0A8754;
        }
        .director-btn {
            background-color: #C3D730;
            color: #1A0DAB;
        }
        .director-btn:hover {
            background-color: #0A8754;
        }
        .evaluator-btn {
            background-color: #C3D730;
            color: #1A0DAB;
        }
        .evaluator-btn:hover {
            background-color: #0A8754;
        }
        .card-img-top {
            height: 100px;
         
        }
 
    
    </style>
</head>

<body>

<div class="container">
    <div class="header-container">
        <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
        <h2>SELECCIONE SU ROL</h2>
    </div>
    <div class="row g-4">

        <div class="col-md-4">
            <div class="card">
                <div class="image-container">
                <img src="img/Admin.jpg" class="card-img-top" alt="Administrador">
               </div>
                
                <div class="card-body text-center">

                    <h4 class="card-title">Administrador</h4>
                    <p class="card-text">Registrar, editar, ver y eliminar datos de los usuarios</p>
                   <br>
                    <form action="login.jsp" method="post">
                        <button type="submit" name="rol" value="Administrador" class="btn btn-role admin-btn">
                            Ingresar
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card">

                <div class="image-container">
                <img src="img/coordinacion.png" class="card-img-top coord-img" alt="Coordinación">
               </div>
               
                <div class="card-body text-center">
                    <h4 class="card-title">Coordinación</h4>
                    <p class="card-text">Crea la idea de anteproyecto, agregar director e informes de estado.</p>
                    <form action="login.jsp" method="post">
                        <button type="submit" name="rol" value="Coordinacion" class="btn btn-role coordination-btn">
                            Ingresar
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card">
                <div class="image-container">
                <img src="img/estudiante.png" class="card-img-top" alt="Estudiante">
               </div>
               
                <div class="card-body text-center">
                    <h4 class="card-title">Estudiante</h4>
                    <p class="card-text">Seleccionar Idea de Proyecto e informe para Ver la Calificación de anteproyectos.</p>
                    <form action="login.jsp" method="post">
                        <button type="submit" name="rol" value="Estudiante" class="btn btn-role student-btn">
                            Ingresar
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card">
                <div class="image-container">
                <img src="img/director.jpg" class="card-img-top" alt="Director">
               </div>
                <div class="card-body text-center">
                    <h4 class="card-title">Director</h4>
                    <p class="card-text">Calificar el anteproyecto subidos por el alumno, aprobar, rechazar, correcciones.</p>
                    <form action="login.jsp" method="post">
                        <button type="submit" name="rol" value="Director" class="btn btn-role director-btn">
                            Ingresar
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card">
                <div class="image-container">
                <img src="img/evaluador.png" class="card-img-top" alt="Evaluador">
               </div>
               
                <div class="card-body text-center">
                    <h4 class="card-title">Evaluador</h4>
                    <p class="card-text">Evalúar proyectos,Aprobar, rechazar anteproyectos .</p>
                    <form action="login.jsp" method="post">
                        <button type="submit" name="rol" value="Evaluador" class="btn btn-role evaluator-btn">
                            Ingresar
                        </button>
                    </form>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
