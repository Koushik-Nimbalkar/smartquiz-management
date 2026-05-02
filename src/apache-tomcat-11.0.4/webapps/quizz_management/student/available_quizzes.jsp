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
    <title>Available Quizzes | Smart Quiz</title>
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
                <li class="active"><a href="available_quizzes"><i class="fa-solid fa-file-pen"></i> Available Quizzes</a></li>
                <li><a href="history"><i class="fa-solid fa-clock-rotate-left"></i> Quiz History</a></li>
                <li><a href="performance"><i class="fa-solid fa-chart-line"></i> Performance</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav">
                <div><h3 class="mb-0 fw-bold">Available Quizzes</h3><p class="text-muted mb-0">Quizzes you can attempt</p></div>
            </div>
            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty quizzes}">
                        <div class="col-12">
                            <div class="glass-card text-center py-5">
                                <i class="fa-solid fa-file-pen fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No quizzes available right now</h5>
                                <p class="text-muted">Check back later or join a class to see quizzes.</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="quiz" items="${quizzes}">
                        <div class="col-md-6 col-lg-4">
                            <div class="glass-card h-100">
                                <div class="mb-2">
                                    <span class="badge ${quiz.status == 'Active' ? 'bg-success' : quiz.status == 'Upcoming' ? 'bg-primary' : 'bg-secondary'} bg-opacity-10 ${quiz.status == 'Active' ? 'text-success' : quiz.status == 'Upcoming' ? 'text-primary' : 'text-secondary'} rounded-pill mb-2">${quiz.status}</span>
                                </div>
                                <h5 class="fw-bold">${quiz.title}</h5>
                                <p class="text-muted small mb-2"><i class="fa-solid fa-chalkboard me-1"></i>${quiz.className}</p>
                                <p class="text-muted small mb-2"><i class="fa-solid fa-clock me-1"></i>${quiz.durationMinutes} minutes</p>
                                <c:if test="${quiz.startTime != null}">
                                    <p class="text-muted small mb-3"><i class="fa-solid fa-calendar me-1"></i><fmt:formatDate value="${quiz.startTime}" pattern="MMM dd, yyyy HH:mm"/></p>
                                </c:if>
                                <c:choose>
                                    <c:when test="${quiz.status == 'Active'}">
                                        <a href="take_quiz?id=${quiz.id}" class="btn btn-premium w-100">Start Quiz</a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline-secondary w-100" disabled>Not Available Yet</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
