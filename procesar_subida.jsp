<%@ page import="java.io.*, java.util.*, javax.servlet.http.*, javax.servlet.annotation.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.*" %>

<%
    // Verificamos si la petición es multipart
    boolean isMultipart = request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/");
    if (isMultipart) {
        // Carpeta donde se guardarán los archivos
        String uploadPath = application.getRealPath("") + File.separator + "subidas";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        try {
            // Usamos Servlet 3.0 API para manejar la subida
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                String fileName = part.getSubmittedFileName();
                if (fileName != null && !fileName.isEmpty()) {
                    String filePath = uploadPath + File.separator + fileName;
                    part.write(filePath);
                }
            }

            out.println("<script>alert('Archivo subido exitosamente.'); window.location.href='alumno.jsp';</script>");
        } catch (Exception e) {
            out.println("<script>alert('Error al subir el archivo: " + e.getMessage() + "'); window.location.href='alumno.jsp';</script>");
        }
    } else {
        out.println("<script>alert('Error: el formulario no contiene archivos.'); window.location.href='alumno.jsp';</script>");
    }
%>
