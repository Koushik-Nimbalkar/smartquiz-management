<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ page import="com.smartquiz.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz History | Smart Quiz</title>
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
                <li><a href="dashboard"><i class="fa-solid fa-chart-pie"></i> My Dashboard</a></li>
                <li><a href="available_quizzes"><i class="fa-solid fa-file-pen"></i> Available Quizzes</a></li>
                <li class="active"><a href="history"><i class="fa-solid fa-clock-rotate-left"></i> Quiz History</a></li>
                <li><a href="performance"><i class="fa-solid fa-chart-line"></i> Performance</a></li>
                <li><a href="${pageContext.request.contextPath}/student/ai_analysis"><i class="fa-solid fa-brain"></i> AI Analysis</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav d-flex justify-content-between align-items-center">
                <div><h3 class="mb-0 fw-bold">Quiz History</h3><p class="text-muted mb-0">Review all your past quiz attempts</p></div>
                <a href="${pageContext.request.contextPath}/student/ai_analysis" class="btn btn-primary"><i class="fa-solid fa-brain me-2"></i>AI Analysis</a>
            </div>
            <div class="table-custom p-0">
                <table class="table table-hover mb-0">
                    <thead><tr><th class="ps-4">Quiz</th><th>Class</th><th>Score</th><th>Accuracy</th><th>Date</th><th>Review</th></tr></thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty history}"><tr><td colspan="6" class="text-center text-muted py-4">No quiz attempts yet. Take a quiz to see your results here.</td></tr></c:when>
                            <c:otherwise>
                                <c:forEach var="h" items="${history}">
                                <tr>
                                    <td class="ps-4 fw-medium">${h.quizTitle}</td>
                                    <td>${h.className}</td>
                                    <td><strong>${h.score}</strong></td>
                                    <td><span class="badge ${h.accuracyPercentage >= 70 ? 'bg-success' : h.accuracyPercentage >= 40 ? 'bg-warning' : 'bg-danger'} bg-opacity-10 ${h.accuracyPercentage >= 70 ? 'text-success' : h.accuracyPercentage >= 40 ? 'text-warning' : 'text-danger'} rounded-pill px-2 py-1">${h.accuracyPercentage}%</span></td>
                                    <td><c:choose><c:when test="${not empty h.startTime}"><fmt:formatDate value="${h.startTime}" pattern="MMM dd, yyyy"/></c:when><c:otherwise>&mdash;</c:otherwise></c:choose></td>
                                    <td><a href="${pageContext.request.contextPath}/student/review?attemptId=${h.id}" class="btn btn-sm btn-outline-primary"><i class="fa-solid fa-eye me-1"></i>Review</a></td>
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
