<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ page import="com.smartquiz.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"FACULTY".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
    <link rel="stylesheet" href="../assets/css/dashboard.css?v=2">
</head>
<body>
    <div class="wrapper">
        <nav id="sidebar">
            <div class="sidebar-header"><h4 class="navbar-brand mb-0 text-primary"><i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz</h4></div>
            <ul class="list-unstyled components">
                <li><a href="dashboard"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
                <li><a href="manage_classes"><i class="fa-solid fa-chalkboard-user"></i> Manage Classes</a></li>
                <li class="active"><a href="manage_students"><i class="fa-solid fa-users"></i> Students</a></li>
                <li><a href="manage_quizzes"><i class="fa-solid fa-file-pen"></i> Quizzes</a></li>
                <li><a href="reports"><i class="fa-solid fa-file-invoice"></i> Reports</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav">
                <div>
                    <h3 class="mb-0 fw-bold">Students</h3>
                    <p class="text-muted mb-0">
                        <c:choose>
                            <c:when test="${not empty selectedClassId}">Students in selected class</c:when>
                            <c:otherwise>All students in your classes</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="d-flex gap-2 align-items-center">
                    <form action="manage_students" method="GET" class="d-flex gap-2">
                        <select name="classId" class="form-select border-0 shadow-sm" onchange="this.form.submit()">
                            <option value="">All Classes</option>
                            <c:forEach var="c" items="${classes}">
                                <option value="${c.id}" ${c.id == selectedClassId ? 'selected' : ''}>${c.name}</option>
                            </c:forEach>
                        </select>
                    </form>
                </div>
            </div>
            <div class="table-custom p-0">
                <table class="table table-hover mb-0">
                    <thead><tr><th class="ps-4">#</th><th>Name</th><th>Email</th><th>Registered</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty students}"><tr><td colspan="4" class="text-center text-muted py-4">No students yet.</td></tr></c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${students}" varStatus="i">
                                    <tr><td class="ps-4">${i.index+1}</td><td class="fw-medium">${s.name}</td><td>${s.email}</td><td><fmt:formatDate value="${s.createdAt}" pattern="MMM dd, yyyy"/></td></tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
