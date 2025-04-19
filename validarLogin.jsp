<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    // Parámetros de conexión a la base de datos
    String url = "jdbc:postgresql://localhost:5432/universidad";
    String usuarioDB = "postgres";
    String contrasenaDB = "123";

    // Recuperamos los datos del formulario de login
    String correo = request.getParameter("usuario");
    String contrasena = request.getParameter("contrasena");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String[] tablas = {"administrador", "director", "coordinador", "alumno", "evaluador"};
    boolean encontrado = false;
    String nombre = "";
    String rol = "";
    int idUsuario = 0;

    try {
        // Establecemos la conexión a la base de datos
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, contrasenaDB);

        // Comprobamos cada tabla de roles
        for (String tabla : tablas) {
            String sql = "SELECT id, nombre FROM " + tabla + " WHERE correo = ? AND contrasena = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, correo);
            stmt.setString(2, contrasena);

            rs = stmt.executeQuery();

            // Si encontramos el usuario, lo procesamos
            if (rs.next()) {
                encontrado = true;
                idUsuario = rs.getInt("id");
                nombre = rs.getString("nombre");

                // Guardamos el id general del usuario en la sesión
                session.setAttribute("id_usuario", idUsuario);

                // Determinamos el rol y lo asignamos en la sesión
                switch (tabla) {
                    case "administrador":
                        rol = "administrador";
                        break;
                    case "director":
                        rol = "director";
                        session.setAttribute("id_director", idUsuario); // Solo para casos específicos

                        break;
                    case "coordinador":
                        rol = "coordinador";
                        break;
                    case "alumno":
                        rol = "alumno";
                        session.setAttribute("id_alumno", idUsuario); // Solo para casos específicos
                        break;
                    case "evaluador":
                        rol = "evaluador";
                        session.setAttribute("id_evaluador", idUsuario); // Solo para casos específicos

                        break;
                }

                break; // Salimos del bucle si ya encontramos el usuario
            }

            if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        }

        // Si se encontró el usuario, redirigimos según el rol
        if (encontrado) {
            session.setAttribute("usuario", nombre);
            session.setAttribute("rol", rol);

            // Redirigimos a la página correspondiente según el rol
            switch (rol) {
                case "administrador":
                    response.sendRedirect("administrador.jsp");
                    break;
                case "director":
                    response.sendRedirect("director.jsp");
                    break;
                case "coordinador":
                    response.sendRedirect("coordinador.jsp");
                    break;
                case "alumno":
                    response.sendRedirect("alumno.jsp");
                    break;
                case "evaluador":
                    response.sendRedirect("evaluador.jsp");
                    break;
            }
        } else {
            // Si no se encuentra el usuario, mostramos un mensaje de error
%>
            <script>
                alert("Correo o contraseña incorrectos.");
                window.location.href = "login.jsp";
            </script>
<%
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        // Cerramos las conexiones
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
