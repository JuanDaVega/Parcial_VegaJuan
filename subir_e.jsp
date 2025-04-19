<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.util.List, java.io.File, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String mensaje = "";
    Integer idEvaluador = (Integer) session.getAttribute("id_evaluador");

    if (idEvaluador == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int idAnteproyecto = 0;
    String titulo = "", alumno = "", evaluador = "", director = "";
    boolean tieneAnteproyecto = false;
    String archivoEvaluador = null;

    // Obtener anteproyecto y datos del evaluador
    try {
        con = DriverManager.getConnection(url, usuarioDB, contrasenaDB);
        String sql = "SELECT a.id, a.titulo, al.nombre AS alumno, ev.nombre AS evaluador, dir.nombre AS director " +
                     "FROM anteproyecto a " +
                     "JOIN alumno al ON a.id_alumno = al.id " +
                     "JOIN evaluador ev ON a.id_evaluador = ev.id " +
                     "JOIN director dir ON a.id_director = dir.id " +
                     "WHERE a.id_evaluador = ?";  // Cambio aquí, usando id_evaluador
        ps = con.prepareStatement(sql);
        ps.setInt(1, idEvaluador);  // Ajuste para evaluar según el evaluador
        rs = ps.executeQuery();

        if (rs.next()) {
            tieneAnteproyecto = true;
            idAnteproyecto = rs.getInt("id");
            titulo = rs.getString("titulo");
            alumno = rs.getString("alumno");
            evaluador = rs.getString("evaluador");
            director = rs.getString("director");
        }

        rs.close();
        ps.close();

        // Obtener archivo subido por el evaluador (si existe)
        if (tieneAnteproyecto) {
            String consultaArchivo = "SELECT archivo_ruta FROM informe_anteproyecto " +
                                     "WHERE id_anteproyecto = ? AND tipo_usuario = 'evaluador' " +
                                     "ORDER BY fecha_subida DESC LIMIT 1";
            ps = con.prepareStatement(consultaArchivo);
            ps.setInt(1, idAnteproyecto);
            rs = ps.executeQuery();

            if (rs.next()) {
                archivoEvaluador = rs.getString("archivo_ruta");
            }
        }

    } catch (Exception e) {
        mensaje = "Error al obtener datos: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception ignored) {}
    }

    // Subida del archivo
    if (tieneAnteproyecto && ServletFileUpload.isMultipartContent(request)) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        String uploadPath = application.getRealPath("") + File.separator + "subidas";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(10 * 1024 * 1024); // 10MB

        try {
            List<FileItem> items = upload.parseRequest(request);
            String fileName = null;
            for (FileItem item : items) {
                if (!item.isFormField()) {
                    fileName = new File(item.getName()).getName();
                    String filePath = uploadPath + File.separator + fileName;
                    item.write(new File(filePath));
                    mensaje = "¡Archivo subido con éxito!";
                }
            }

            if (fileName != null) {
                con = DriverManager.getConnection(url, usuarioDB, contrasenaDB);
                String insertarSQL = "INSERT INTO informe_anteproyecto (id_anteproyecto, tipo_usuario, archivo_ruta) VALUES (?, ?, ?)";
                ps = con.prepareStatement(insertarSQL);
                ps.setInt(1, idAnteproyecto);
                ps.setString(2, "evaluador");  
                ps.setString(3, "subidas/" + fileName);
                ps.executeUpdate();
                archivoEvaluador = "subidas/" + fileName;
            }

        } catch (Exception e) {
            mensaje = "Error al subir el archivo: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }

    request.setAttribute("mensaje", mensaje);
%>

<html>
<head>
    <title>Subir Anteproyecto</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="style.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="header-container">
        <img src="https://www.uts.edu.co/sitio/wp-content/uploads/2019/10/Logo-UTS-1.png" alt="Unidades Tecnológicas de Santander" class="logo-uts">
        <h2 class="text-center">SUBIR DOCUMENTOS</h2>
    </div>
<br>
    <% if (mensaje != null && !mensaje.isEmpty()) { %>
        <div class="alert alert-info text-center"><%= mensaje %></div>
    <% } %>

    <% if (tieneAnteproyecto) { %>
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="table-info">
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Alumno</th>
                    <th>Evaluador</th>
                    <th>Director</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><%= idAnteproyecto %></td>
                    <td><%= titulo %></td>
                    <td><%= alumno %></td>
                    <td><%= evaluador %></td>
                    <td><%= director %></td>
                </tr>
                </tbody>
            </table>
        </div>

        <form action="subir_e.jsp" method="post" enctype="multipart/form-data" class="mt-4">
            <input type="hidden" name="id_anteproyecto" value="<%= idAnteproyecto %>">
            <div class="mb-3">
                <label for="archivo" class="form-label">Seleccionar Archivo:</label>
                <input class="form-control" type="file" name="archivo" id="archivo" required>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary">Subir Archivo</button>
                <a href="evaluador.jsp" class="btn btn-secondary ms-2">Cancelar</a>
            </div>
        </form>

        <% if (archivoEvaluador != null) { %>
            <div class="alert alert-success mt-4 text-center">
                <strong>Archivo subido:</strong>
                <a href="<%= archivoEvaluador %>" target="_blank">
                    <%= archivoEvaluador.substring(archivoEvaluador.lastIndexOf('/') + 1) %>
                </a>
            </div>
        <% } else { %>
            <div class="alert alert-secondary mt-4 text-center">
                Aún no has subido ningún archivo.
            </div>
        <% } %>

    <% } else { %>
        <div class="alert alert-warning text-center">
            Aún no tienes un anteproyecto asignado. Por favor selecciona uno desde la plataforma.
        </div>
        <div class="text-center">
            <a href="index.jsp" class="btn btn-secondary">Volver al inicio</a>
        </div>
    <% } %>

    <div class="text-center mt-5">
        <a href="evaluador.jsp" class="btn btn-outline-success">Volver</a>
    </div>

</div>
</body>
</html>
