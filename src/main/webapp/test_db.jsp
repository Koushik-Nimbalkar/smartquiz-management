<%@ page import="java.sql.*, java.io.*" %>
<html>
<body>
<h2>Database Connection Test</h2>
<%
    String url = "jdbc:mysql://localhost:3306/smartquiz_db?useSSL=false&serverTimezone=UTC";
    String user = "root";
    String pass = "1234";

    out.println("<p>Testing Driver...</p>");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        out.println("<p style='color:green'>Driver Loaded Successfully!</p>");
    } catch (Exception e) {
        out.println("<p style='color:red'>Driver Failed: " + e.getMessage() + "</p>");
    }

    out.println("<p>Testing Connection...</p>");
    try (Connection conn = DriverManager.getConnection(url, user, pass)) {
        out.println("<p style='color:green'>Connection Successful!</p>");
    } catch (Exception e) {
        out.println("<p style='color:red'>Connection Failed: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>
