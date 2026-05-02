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
    <title>Admin Dashboard | Smart Quiz</title>
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
                <li class="active"><a href="dashboard"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
                <li><a href="manage_classes"><i class="fa-solid fa-chalkboard-user"></i> Manage Classes</a></li>
                <li><a href="manage_students"><i class="fa-solid fa-users"></i> Students</a></li>
                <li><a href="manage_quizzes"><i class="fa-solid fa-file-pen"></i> Quizzes</a></li>
                <li><a href="reports"><i class="fa-solid fa-file-invoice"></i> Reports</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav">
                <div>
                    <h3 class="mb-0 fw-bold">Overview</h3>
                    <p class="text-muted mb-0">Welcome back, <%= user.getName() %>!</p>
                </div>
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle profile-dropdown" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=<%= java.net.URLEncoder.encode(user.getName(), "UTF-8") %>&background=4F46E5&color=fff" alt="User">
                        <span class="ms-2 d-none d-md-inline text-dark fw-medium"><%= user.getName() %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth?action=logout">Sign out</a></li>
                    </ul>
                </div>
            </div>

            <!-- Stat Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card"><div><p class="text-muted mb-1">Total Students</p><h3 class="fw-bold mb-0">${stats.totalStudents}</h3></div><div class="stat-icon primary"><i class="fa-solid fa-users"></i></div></div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card"><div><p class="text-muted mb-1">Active Quizzes</p><h3 class="fw-bold mb-0">${stats.activeQuizzes}</h3></div><div class="stat-icon warning"><i class="fa-solid fa-file-pen"></i></div></div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card"><div><p class="text-muted mb-1">Avg. Score</p><h3 class="fw-bold mb-0">${stats.overallAvgScore}%</h3></div><div class="stat-icon success"><i class="fa-solid fa-chart-line"></i></div></div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card"><div><p class="text-muted mb-1">Cheat Alerts</p><h3 class="fw-bold mb-0 text-danger">${stats.cheatAlerts}</h3></div><div class="stat-icon danger"><i class="fa-solid fa-triangle-exclamation"></i></div></div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="row g-4 mb-4">
                <div class="col-12">
                    <div class="glass-card">
                        <h5 class="fw-bold mb-3">Quick Actions</h5>
                        <div class="d-flex flex-wrap gap-3">
                            <a href="manage_quizzes" class="btn btn-premium rounded-pill px-4">
                                <i class="fa-solid fa-plus me-2"></i>Create New Quiz
                            </a>
                            <a href="manage_classes" class="btn btn-outline-primary rounded-pill px-4">
                                <i class="fa-solid fa-chalkboard-user me-2"></i>Manage Classes
                            </a>
                            <a href="reports" class="btn btn-outline-secondary rounded-pill px-4">
                                <i class="fa-solid fa-file-invoice me-2"></i>View Reports
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts & Alerts -->
            <div class="row g-4">
                <div class="col-md-8">
                    <div class="glass-card h-100">
                        <h5 class="fw-bold mb-4">Performance Overview</h5>
                        <canvas id="performanceChart" height="100"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="glass-card h-100">
                        <h5 class="fw-bold mb-4">Recent Alerts</h5>
                        <ul class="list-group list-group-flush">
                            <c:choose>
                                <c:when test="${empty recentAlerts}">
                                    <li class="list-group-item px-0 bg-transparent text-muted text-center">No alerts. All clear!</li>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="alert" items="${recentAlerts}">
                                        <li class="list-group-item px-0 bg-transparent">
                                            <div class="d-flex align-items-center">
                                                <div class="bg-danger bg-opacity-10 text-danger rounded-circle p-2 me-3"><i class="fa-solid fa-window-restore"></i></div>
                                                <div>
                                                    <h6 class="mb-0 text-dark">${alert.tabSwitches} Tab Switch(es)</h6>
                                                    <small class="text-muted">${alert.studentName} - ${alert.quizTitle}</small>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Recent Quizzes Table -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="table-custom p-0">
                        <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-white">
                            <h5 class="fw-bold mb-0">Recent Quizzes</h5>
                            <a href="manage_quizzes" class="btn btn-sm btn-outline-primary">View All</a>
                        </div>
                        <table class="table table-hover mb-0">
                            <thead><tr><th class="ps-4">Quiz Title</th><th>Class</th><th>Date</th><th>Status</th><th class="pe-4 text-end">Action</th></tr></thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty stats.recentQuizzes}"><tr><td colspan="5" class="text-center text-muted py-4">No recent quizzes found.</td></tr></c:when>
                                    <c:otherwise>
                                        <c:forEach var="quiz" items="${stats.recentQuizzes}">
                                        <tr>
                                            <td class="ps-4 fw-medium">${quiz.title}</td>
                                            <td>${quiz.className}</td>
                                            <td><fmt:formatDate value="${quiz.createdAt}" pattern="MMM dd, yyyy" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${quiz.status == 'Completed'}"><span class="badge bg-success bg-opacity-10 text-success px-2 py-1 rounded-pill">Completed</span></c:when>
                                                    <c:when test="${quiz.status == 'Active'}"><span class="badge bg-primary bg-opacity-10 text-primary px-2 py-1 rounded-pill">Active</span></c:when>
                                                    <c:otherwise><span class="badge bg-warning bg-opacity-10 text-warning px-2 py-1 rounded-pill">${quiz.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="pe-4 text-end"><a href="manage_quizzes" class="btn btn-sm btn-light"><i class="fa-solid fa-eye"></i></a></td>
                                        </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="text-center small text-muted mt-4 pb-2">
                &copy; 2026 Smart Quiz Management System. All rights reserved.
                <span class="fw-semibold text-secondary ms-1">Koushik-CSE@2026</span>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctx = document.getElementById('performanceChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Total Students', 'Active Quizzes', 'Avg Score', 'Cheat Alerts'],
                datasets: [{
                    label: 'Value',
                    data: [${stats.totalStudents}, ${stats.activeQuizzes}, ${stats.overallAvgScore}, ${stats.cheatAlerts}],
                    backgroundColor: ['rgba(79, 70, 229, 0.8)', 'rgba(245, 158, 11, 0.8)', 'rgba(16, 185, 129, 0.8)', 'rgba(239, 68, 68, 0.8)'],
                    borderRadius: 6
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });
    </script>
</body>
</html>
