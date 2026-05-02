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
    <title>Student Dashboard | Smart Quiz</title>
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
                <li class="active"><a href="dashboard"><i class="fa-solid fa-chart-pie"></i> My Dashboard</a></li>
                <li><a href="available_quizzes"><i class="fa-solid fa-file-pen"></i> Available Quizzes</a></li>
                <li><a href="history"><i class="fa-solid fa-clock-rotate-left"></i> Quiz History</a></li>
                <li><a href="performance"><i class="fa-solid fa-chart-line"></i> Performance</a></li>
                <li><a href="${pageContext.request.contextPath}/student/ai_analysis"><i class="fa-solid fa-brain"></i> AI Analysis</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav">
                <div>
                    <h3 class="mb-0 fw-bold">My Dashboard</h3>
                    <p class="text-muted mb-0">Hello, <%= user.getName() %>! Here's your academic progress.</p>
                </div>
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle profile-dropdown" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(user.getName(), "UTF-8") %>&background=10B981&color=fff" alt="User">
                        <span class="ms-2 d-none d-md-inline text-dark fw-medium"><%= user.getName() %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth?action=logout">Sign out</a></li>
                    </ul>
                </div>
            </div>

            <!-- Stat Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="stat-card"><div><p class="text-muted mb-1">Quizzes Taken</p><h3 class="fw-bold mb-0">${stats.quizzesTaken}</h3></div><div class="stat-icon primary"><i class="fa-solid fa-check-double"></i></div></div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card"><div><p class="text-muted mb-1">Average Score</p><h3 class="fw-bold mb-0">${stats.averageScore}%</h3></div><div class="stat-icon success"><i class="fa-solid fa-trophy"></i></div></div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card"><div><p class="text-muted mb-1">Pending Quizzes</p><h3 class="fw-bold mb-0 text-warning">${stats.pendingQuizzes}</h3></div><div class="stat-icon warning"><i class="fa-solid fa-clock"></i></div></div>
                </div>
            </div>

            <!-- Charts & Upcoming -->
            <div class="row g-4">
                <div class="col-md-8">
                    <div class="glass-card h-100">
                        <h5 class="fw-bold mb-4">My Progress</h5>
                        <canvas id="progressChart" height="100"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card h-100">
                        <h5 class="fw-bold mb-4">Upcoming Quizzes</h5>
                        <div class="d-flex flex-column gap-3">
                            <c:choose>
                                <c:when test="${empty stats.upcomingQuizzes}">
                                    <div class="p-3 text-center text-muted"><p class="mb-0">No upcoming quizzes scheduled.</p></div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="quiz" items="${stats.upcomingQuizzes}">
                                        <div class="p-3 border rounded-3 bg-white shadow-sm border-start border-4 border-primary">
                                            <h6 class="fw-bold mb-1">${quiz.className} - ${quiz.title}</h6>
                                            <p class="text-muted small mb-2"><i class="fa-solid fa-calendar me-1"></i> ${quiz.startTime}</p>
                                            <a href="take_quiz?id=${quiz.id}" class="btn btn-sm btn-outline-primary w-100">Take Quiz</a>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity & Quick Actions -->
            <div class="row g-4 mt-2">
                <div class="col-lg-8">
                    <div class="glass-card">
                        <h5 class="fw-bold mb-4"><i class="fa-solid fa-bolt text-warning me-2"></i>Quick Actions</h5>
                        <div class="row g-3">
                            <div class="col-sm-6 col-md-4">
                                <a href="available_quizzes" class="text-decoration-none">
                                    <div class="action-item bg-primary">
                                        <i class="fa-solid fa-file-pen mb-2"></i>
                                        <h6>Take Quiz</h6>
                                    </div>
                                </a>
                            </div>
                            <div class="col-sm-6 col-md-4">
                                <a href="#" data-bs-toggle="modal" data-bs-target="#joinClassModal" class="text-decoration-none">
                                    <div class="action-item bg-info">
                                        <i class="fa-solid fa-plus-circle mb-2"></i>
                                        <h6>Join Class</h6>
                                    </div>
                                </a>
                            </div>
                            <div class="col-sm-6 col-md-4">
                                <a href="history" class="text-decoration-none">
                                    <div class="action-item bg-success">
                                        <i class="fa-solid fa-clock-rotate-left mb-2"></i>
                                        <h6>History</h6>
                                    </div>
                                </a>
                            </div>
                            <div class="col-sm-6 col-md-4">
                                <a href="performance" class="text-decoration-none">
                                    <div class="action-item bg-warning">
                                        <i class="fa-solid fa-chart-line mb-2"></i>
                                        <h6>Performance</h6>
                                    </div>
                                </a>
                            </div>
                            <div class="col-sm-6 col-md-4">
                                <a href="${pageContext.request.contextPath}/student/ai_analysis" class="text-decoration-none">
                                    <div class="action-item bg-indigo">
                                        <i class="fa-solid fa-brain mb-2"></i>
                                        <h6>AI Analysis</h6>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="glass-card h-100">
                        <h5 class="fw-bold mb-4"><i class="fa-solid fa-rss text-danger me-2"></i>Recent Activity</h5>
                        <div class="activity-feed">
                            <c:choose>
                                <c:when test="${empty recentActivity}">
                                    <p class="text-muted small text-center py-4">No recent activity logged.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="activity" items="${recentActivity}">
                                        <div class="activity-item pb-3 mb-3 border-bottom border-light">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <p class="mb-0 small fw-medium">${activity.split('\\|')[0]}</p>
                                                <span class="text-muted smaller" style="font-size: 0.7rem;">${activity.split('\\|')[1].substring(0, 16)}</span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-center small text-muted mt-4 pb-2">
                &copy; 2026 Smart Quiz Management System. All rights reserved.
                <span class="fw-semibold text-secondary ms-1">Koushik-CSE@2026</span>
            </div>
        </div>
    </div>

    <!-- Join Class Modal -->
    <div class="modal fade" id="joinClassModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Join New Class</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="join_class" method="POST">
                    <div class="modal-body text-center py-4">
                        <i class="fa-solid fa-key fa-3x text-info mb-3"></i>
                        <p class="text-muted">Enter the 8-character code provided by your instructor.</p>
                        <input type="text" name="joinCode" class="form-control form-control-lg text-center fw-bold" placeholder="E.G. AB12CD34" maxlength="8" required>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-premium px-4">Join Class</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctx = document.getElementById('progressChart').getContext('2d');
        const labels = ${labelsJson};
        const scores = ${scoresJson};
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels.length > 0 ? labels : ['No data yet'],
                datasets: [{
                    label: 'My Score (%)',
                    data: scores.length > 0 ? scores : [0],
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
