<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Obtener el id del alumno desde la sesión (asumimos que el ID está en la sesión)
    Object idAlumnoObj = session.getAttribute("id_alumno");
    int idAlumno = -1;

    if (idAlumnoObj != null) {
        idAlumno = Integer.parseInt(idAlumnoObj.toString());
    }

    String titulo = "";
    String estadoDirector = "";
    String estadoEvaluador = "";
    String alumno = "";
    String director = "";
    String evaluador = "";

    if (idAlumno != -1) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/universidad", "postgres", "123");

            // Consulta para obtener los detalles del anteproyecto y los nombres de los involucrados
            String sql = "SELECT a.titulo, al.nombre AS alumno, d.nombre AS director, e.nombre AS evaluador, " +
                         "(SELECT estado FROM informe_anteproyecto ia1 WHERE ia1.id_anteproyecto = a.id AND ia1.tipo_usuario = 'director' LIMIT 1) AS estado_director, " +
                         "(SELECT estado FROM informe_anteproyecto ia2 WHERE ia2.id_anteproyecto = a.id AND ia2.tipo_usuario = 'evaluador' LIMIT 1) AS estado_evaluador " +
                         "FROM anteproyecto a " +
                         "JOIN alumno al ON a.id_alumno = al.id " +
                         "JOIN director d ON d.id = a.id_director " +
                         "JOIN evaluador e ON e.id = a.id_evaluador " +
                         "WHERE al.id = ?";

            ps = con.prepareStatement(sql);
            ps.setInt(1, idAlumno);
            rs = ps.executeQuery();

            if (rs.next()) {
                titulo = rs.getString("titulo");
                alumno = rs.getString("alumno");
                director = rs.getString("director");
                evaluador = rs.getString("evaluador");
                estadoDirector = rs.getString("estado_director");
                estadoEvaluador = rs.getString("estado_evaluador");
            }

        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>calificaciones</title>
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

      .card {
          margin-top: 20px;
          border-radius: 15px;
          overflow: hidden;
          box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
          background-color: #fff;
      }

      .card-body {
          padding: 25px;
      }

      .estado-label {
          font-weight: bold;
      }
      .estado-aprobado {
          color: green;
      }
      .estado-rechazado {
          color: red;
      }
      .estado-corregido {
          color: orange;
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

      .container {
          max-width: 1200px;
      }

    </style>
</head>
<body>

    <div class="container">
      <div class="header-container">
        <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
        <h2>CALIFICACIÓN</h2>
      </div>

      <br>

      <% if (!titulo.isEmpty() && !alumno.isEmpty()) { %>
        <div class="card">
          <div class="card-body">
            <h5 class="card-title"><strong>Título del Anteproyecto:</strong> <%= titulo %></h5>
            <p><strong>Alumno:</strong> <%= alumno %></p>
            <p><strong>Director:</strong> <%= director %></p>
            <p><strong>Evaluador:</strong> <%= evaluador %></p>
            <p><strong>Estado del Informe por el Director:</strong>
              <span class="estado-label <%= ("Aprobado".equalsIgnoreCase(estadoDirector)) ? "estado-aprobado" : ("Rechazado".equalsIgnoreCase(estadoDirector)) ? "estado-rechazado" : "estado-corregido" %>">
                <%= (estadoDirector != null && !estadoDirector.isEmpty()) ? estadoDirector : "No actualizado" %>
              </span>
            </p>
            <p><strong>Estado del Informe por el Evaluador:</strong>
              <span class="estado-label <%= ("Aprobado".equalsIgnoreCase(estadoEvaluador)) ? "estado-aprobado" : ("Rechazado".equalsIgnoreCase(estadoEvaluador)) ? "estado-rechazado" : "estado-corregido" %>">
                <%= (estadoEvaluador != null && !estadoEvaluador.isEmpty()) ? estadoEvaluador : "No actualizado" %>
              </span>
            </p>

            <% if ("Rechazado".equalsIgnoreCase(estadoDirector)) { %>
              <div class="alert alert-danger mt-3">
                  El director ha <strong>rechazado</strong> el informe. No se enviará al evaluador.
              </div>
            <% } %>

          </div>
        </div>

        <!-- Tabla con la información detallada del informe -->
        <div class="mt-4">
            <h4>Detalles del Informe</h4>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Nombre del Informe</th>
                        <th>Alumno</th>
                        <th>Director</th>
                        <th>Evaluador</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><%= titulo %></td>
                        <td><%= alumno %></td>
                        <td><%= director %></td>
                        <td><%= evaluador %></td>
                    </tr>
                </tbody>
            </table>
        </div>
      <% } else { %>
        <div class="alert alert-warning">
            No se ha encontrado el anteproyecto para este alumno.
        </div>
      <% } %>

      <div class="text-center mt-4">
          <a href="alumno.jsp" class="btn btn-outline-dark">Volver</a>
      </div>
    </div>

</body>
</html>
