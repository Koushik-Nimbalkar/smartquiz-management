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
    <title>Manage Classes | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
    <link rel="stylesheet" href="../assets/css/dashboard.css?v=2">
</head>
<body>
    <div class="wrapper">
        <nav id="sidebar">
            <div class="sidebar-header">
                <h4 class="navbar-brand mb-0 text-primary"><i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz</h4>
            </div>
            <ul class="list-unstyled components">
                <li><a href="dashboard"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
                <li class="active"><a href="manage_classes"><i class="fa-solid fa-chalkboard-user"></i> Manage Classes</a></li>
                <li><a href="manage_students"><i class="fa-solid fa-users"></i> Students</a></li>
                <li><a href="manage_quizzes"><i class="fa-solid fa-file-pen"></i> Quizzes</a></li>
                <li><a href="reports"><i class="fa-solid fa-file-invoice"></i> Reports</a></li>
                <li class="mt-5">
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
                </li>
            </ul>
        </nav>

        <div id="content">
            <div class="dashboard-nav">
                <div>
                    <h3 class="mb-0 fw-bold">Manage Classes</h3>
                    <p class="text-muted mb-0">Create and manage your classrooms</p>
                </div>
                <button class="btn btn-premium" data-bs-toggle="modal" data-bs-target="#createClassModal">
                    <i class="fa-solid fa-plus me-2"></i>Create Class
                </button>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty classes}">
                        <div class="col-12">
                            <div class="glass-card text-center py-5">
                                <i class="fa-solid fa-chalkboard-user fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No classes created yet</h5>
                                <p class="text-muted">Click "Create Class" to get started</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="cls" items="${classes}">
                            <div class="col-md-4">
                                <div class="glass-card h-100">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h5 class="fw-bold mb-1">${cls.name}</h5>
                                            <p class="text-muted small mb-0">by ${cls.facultyName}</p>
                                        </div>
                                        <a href="manage_classes?action=delete&id=${cls.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this class? All enrollments will be removed.')"><i class="fa-solid fa-trash"></i></a>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="text-muted small"><i class="fa-solid fa-users me-1"></i> ${cls.studentCount} students</span>
                                        <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-1 rounded-pill fw-bold">${cls.joinCode}</span>
                                    </div>
                                    <small class="text-muted"><i class="fa-solid fa-calendar me-1"></i> Created: <fmt:formatDate value="${cls.createdAt}" pattern="MMM dd, yyyy" /></small>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Create Class Modal -->
    <div class="modal fade" id="createClassModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Create New Class</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="manage_classes" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Class Name</label>
                            <input type="text" class="form-control" name="name" required placeholder="e.g., CS101 - Data Structures">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Join Code <small class="text-muted">(leave blank to auto-generate)</small></label>
                            <input type="text" class="form-control" name="joinCode" placeholder="e.g., CS101-2026">
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-premium">Create Class</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
