<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
    <title>Performance | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
    <link rel="stylesheet" href="../assets/css/dashboard.css?v=2">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="wrapper">
        <nav id="sidebar">
            <div class="sidebar-header"><h4 class="navbar-brand mb-0 text-primary"><i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz</h4></div>
            <ul class="list-unstyled components">
                <li><a href="dashboard"><i class="fa-solid fa-chart-pie"></i> My Dashboard</a></li>
                <li><a href="available_quizzes"><i class="fa-solid fa-file-pen"></i> Available Quizzes</a></li>
                <li><a href="history"><i class="fa-solid fa-clock-rotate-left"></i> Quiz History</a></li>
                <li class="active"><a href="performance"><i class="fa-solid fa-chart-line"></i> Performance</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav">
                <div><h3 class="mb-0 fw-bold">Performance Analytics</h3><p class="text-muted mb-0">Track your progress over time</p></div>
            </div>
            <div class="row g-4">
                <div class="col-md-8">
                    <div class="glass-card h-100">
                        <h5 class="fw-bold mb-4">Score Trend</h5>
                        <canvas id="performanceChart" height="120"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card h-100">
                        <h5 class="fw-bold mb-4">Summary</h5>
                        <c:choose>
                            <c:when test="${empty history}">
                                <p class="text-muted">Take some quizzes to see your performance summary.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="mb-3 p-3 bg-primary bg-opacity-10 rounded-3">
                                    <p class="text-muted small mb-1">Total Quizzes Taken</p>
                                    <h4 class="fw-bold mb-0 text-primary">${history.size()}</h4>
                                </div>
                                <div class="p-3 bg-success bg-opacity-10 rounded-3">
                                    <p class="text-muted small mb-1">Latest Score</p>
                                    <h4 class="fw-bold mb-0 text-success">${history.get(0).accuracyPercentage}%</h4>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctx = document.getElementById('performanceChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ${labelsJson},
                datasets: [{
                    label: 'Accuracy (%)',
                    data: ${scoresJson},
                    borderColor: '#10B981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    borderWidth: 3, fill: true, tension: 0.4
                }]
            },
            options: {
                responsive: true,
                scales: { y: { beginAtZero: true, max: 100 } },
                plugins: { legend: { display: false } }
            }
        });
    </script>
</body>
</html>
