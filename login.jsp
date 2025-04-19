<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 30px;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
            background-color: white;
            margin-bottom: 10px;
        }
        .login-card h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #1A0DAB;
            font-weight: bold;
        }
        .form-control {
            border-radius: 10px;
        }
        .btn-login {
            background-color: #C3D730;
            color: #1A0DAB;
            font-weight: bold;
            border-radius: 10px;
        }
        .btn-login:hover {
            background-color: #0A8754;
            color: white;
        }
        .credentials-card {
            width: 100%;
            max-width: 400px;
            padding: 20px;
            border-radius: 15px;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            font-size: 14px;
            margin-top: 10px;
        }
        .credentials-card h5 {
            text-align: center;
            color: #0A8754;
            margin-bottom: 15px;
        }
        .credentials-card ul {
            padding-left: 20px;
        }
        .btn-info-small {
            font-size: 18px;
            padding: 4px 8px;
            border-radius: 12px;
            margin-top: 10px;
            color: white;
            border: none;
        }
        .btn-info-small:hover {
            background-color: #0A8754;
        }
    </style>
</head>

<body>

<div class="login-card">
    <h2>Iniciar Sesión</h2>
    <form action="validarLogin.jsp" method="post">
        <div class="mb-3">
            <label for="usuario" class="form-label">Usuario</label>
            <input type="text" class="form-control" id="usuario" name="usuario" placeholder="correo" required>
        </div>
        <div class="mb-3">
            <label for="contrasena" class="form-label">Contraseña</label>
            <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="contraseña" required>
        </div>
        <button type="submit" class="btn btn-login w-100">Ingresar</button>
    </form>

    <div class="text-center">
    <button class="btn btn-info-small" type="button" data-bs-toggle="collapse" data-bs-target="#credenciales" aria-expanded="false" aria-controls="credenciales">
        ℹ️ 
    </button>
</div>
    <div class="collapse" id="credenciales">
        <div class="credentials-card">
            <h5>Credenciales de Prueba</h5>
            <ul>
                <li><strong>Administrador:</strong> admin@uts.edu.co / 123</li>
                <li><strong>Coordinación:</strong> maria@uts.edu.co / 123</li>

                <li><strong>Alumno:</strong> andres@uts.edu.co / 123</li>

                <li><strong>Director:</strong> mariano@uts.edu.co / 123</li>
                <li><strong>Evaluador:</strong> jose@uts.edu.co / 123</li>

            </ul>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
