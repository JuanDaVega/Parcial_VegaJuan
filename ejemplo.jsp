<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.File" %>

<%
    if (ServletFileUpload.isMultipartContent(request)) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        String uploadPath = application.getRealPath("") + File.separator + "subidas";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        List<org.apache.commons.fileupload.FileItem> items = new ServletFileUpload(factory).parseRequest(request);
        for (org.apache.commons.fileupload.FileItem item : items) {
            if (!item.isFormField()) {
                String fileName = new File(item.getName()).getName();
                File uploadedFile = new File(uploadPath + File.separator + fileName);
                item.write(uploadedFile);
            }
        }
    }
%>
<html>
    <body>
        <form action="subir.jsp" method="post" enctype="multipart/form-data">
            <input type="file" name="file" />
            <input type="submit" value="Upload" />
        </form>
    </body>
</html>
