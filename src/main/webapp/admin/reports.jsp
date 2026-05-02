<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ page import="com.smartquiz.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"FACULTY".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports | Smart Quiz</title>
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
                <li><a href="manage_students"><i class="fa-solid fa-users"></i> Students</a></li>
                <li><a href="manage_quizzes"><i class="fa-solid fa-file-pen"></i> Quizzes</a></li>
                <li class="active"><a href="reports"><i class="fa-solid fa-file-invoice"></i> Reports</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav">
                <div><h3 class="mb-0 fw-bold">Reports & Analytics</h3><p class="text-muted mb-0">View quiz results and integrity alerts</p></div>
            </div>
            <!-- Cheating Alerts -->
            <c:if test="${not empty cheatingAlerts}">
            <div class="glass-card mb-4">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-triangle-exclamation text-danger me-2"></i>Integrity Alerts</h5>
                <div class="row g-3">
                    <c:forEach var="alert" items="${cheatingAlerts}">
                    <div class="col-md-4">
                        <div class="p-3 bg-danger bg-opacity-10 border border-danger border-opacity-25 rounded-3">
                            <h6 class="fw-bold text-danger mb-1">${alert.studentName}</h6>
                            <p class="small mb-1">${alert.quizTitle}</p>
                            <span class="badge bg-danger">${alert.tabSwitches} tab switches</span>
                        </div>
                    </div>
                    </c:forEach>
                </div>
            </div>
            </c:if>
            <!-- Results Table -->
            <div class="table-custom p-0">
                <div class="p-3 border-bottom bg-white"><h5 class="fw-bold mb-0">All Quiz Results</h5></div>
                <table class="table table-hover mb-0">
                    <thead><tr><th class="ps-4">Student</th><th>Quiz</th><th>Class</th><th>Score</th><th>Accuracy</th><th>Date</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty attempts}"><tr><td colspan="6" class="text-center text-muted py-4">No results yet.</td></tr></c:when>
                            <c:otherwise>
                                <c:forEach var="a" items="${attempts}">
                                <tr>
                                    <td class="ps-4 fw-medium">${a.studentName}</td>
                                    <td>${a.quizTitle}</td><td>${a.className}</td>
                                    <td>${a.score}</td>
                                    <td><span class="badge ${a.accuracyPercentage >= 70 ? 'bg-success' : a.accuracyPercentage >= 40 ? 'bg-warning' : 'bg-danger'} bg-opacity-10 ${a.accuracyPercentage >= 70 ? 'text-success' : a.accuracyPercentage >= 40 ? 'text-warning' : 'text-danger'} rounded-pill">${a.accuracyPercentage}%</span></td>
                                    <td><fmt:formatDate value="${a.startTime}" pattern="MMM dd, yyyy"/></td>
                                </tr>
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
