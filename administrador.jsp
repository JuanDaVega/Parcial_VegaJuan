<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Administrar Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

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
        .btt-btn {
            background-color: #C3D730;
            color: #1A0DAB;
        }
        .btt-btn:hover {
            background-color: #0A8754;
        }
        
        .card-img-top {
            height: 100px;
         
        }
 
    
    </style>




</head>


<body class="bg-light">

<div class="container mt-5">
    <div class="header-container">
        <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
        <h2 class="text-center">ADMINISTRADOR</h2>
    </div>   
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="image-container">
                    <img src="img/director.jpg" class="card-img-top" alt="Administrador">
                   </div>
                <div class="card-body text-center">
                    <h5 class="card-title">Lista de Directores</h5>
                    <p class="card-text">Gestionar todos los directorios registrados.</p>
                    <a href="lista.jsp?rol=director" class="btn btn-role btt-btn">Ver Directores</a>
                </div>
            </div>
        </div>

 <!-- Panel Alumnos -->
 <div class="col-md-4">
    <div class="card h-100 shadow-sm">
        <div class="image-container">
            <img src="img/evaluador.png" class="card-img-top" alt="Administrador">
           </div>
        <div class="card-body text-center">
            <h5 class="card-title">Lista de Evaluadores</h5>
            <p class="card-text">Gestionar todos los Evaluadores registrados.</p>
            <a href="lista.jsp?rol=evaluador" class="btn btn-role btt-btn">Ver Evaluadores</a>
        </div>
    </div>
</div>

        <!-- Panel Alumnos -->
        <div class="col-md-4">
            <div class="card h-100 shadow-sm">
                <div class="image-container">
                    <img src="img/estudiante.png" class="card-img-top" alt="Administrador">
                   </div>
                <div class="card-body text-center">
                    <h5 class="card-title">Lista de Alumnos</h5>
                    <p class="card-text">Gestionar todos los alumnos registrados.</p>
                    <a href="lista.jsp?rol=alumno" class="btn btn-role btt-btn">Ver Alumnos</a>
                </div>
            </div>
        </div>

        <!-- Panel Coordinadores -->
        <div class="col-md-4 offset-md-4">
            <div class="card h-100 shadow-sm">
                <div class="image-container">
                    <img src="img/coordinacion.png" class="card-img-top" alt="Administrador">
                   </div>
                <div class="card-body text-center">
                    <h5 class="card-title">Lista de Coordinadores</h5>
                    <p class="card-text">Gestionar todos los coordinadores registrados.</p>
                    <a href="lista.jsp?rol=coordinador" class="btn btn-role btt-btn">Ver Coordinadores</a>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center mt-5">
        <a href="registro_usuario.jsp" class="btn btn-outline-primary me-3">Registrar Nuevo Usuario</a>
        <a href="index.jsp" class="btn btn-outline-success">Volver al Inicio</a>
    </div>

</div>

</body>
</html>
