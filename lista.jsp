<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    String rol = request.getParameter("rol");
    String mensaje = request.getParameter("mensaje");
%>

<html>
<head>
    <title>Lista de Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="style.css">
    <style>
        body {
            background: linear-gradient(135deg, #ece9e6, #ffffff);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px;
        }
        .card-custom {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid #ddd;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 30px;
            width: 100%;
            max-width: 1000px;
        }
        .table-custom {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            overflow: hidden;
        }
        .btn-custom {
            border-radius: 20px;
            padding: 6px 15px;
            font-size: 14px;
        }
        h2 {
            font-weight: bold;
            color: #333;
        }
        .table thead {
            background: #343a40;
            color: white;
        }
        .table-hover tbody tr:hover {
            background-color: #f1f1f1;
        }
        .alert {
            border-radius: 10px;
        }
    </style>
</head>

<body>

    
    
<div class="card-custom">
    <h2 class="mb-4 text-center">Lista de Usuarios (<%= rol %>)</h2>

    <% if (mensaje != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= mensaje %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="table-responsive table-custom">
        <table class="table table-striped table-hover align-middle text-center">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Correo</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("org.postgresql.Driver");
                    conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

                    String sql = "SELECT * FROM " + rol;
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("correo") %></td>
                    <td>
                        <a href="editar_usuario.jsp?rol=<%= rol %>&id=<%= rs.getInt("id") %>" class="btn btn-success btn-sm btn-custom">Editar</a>
                        <a href="eliminar_usuario.jsp?rol=<%= rol %>&id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm btn-custom">Eliminar</a>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (stmt != null) try { stmt.close(); } catch (Exception e) {}
                    if (conn != null) try { conn.close(); } catch (Exception e) {}
                }
            %>
            </tbody>
        </table>
    </div>

    <div class="text-center mt-4">
        <a href="administrador.jsp" class="btn btn-primary btn-lg btn-custom">Volver</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</div>
</body>
</html>
