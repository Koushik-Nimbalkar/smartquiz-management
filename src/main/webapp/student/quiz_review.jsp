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
    <title>Quiz Review | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
    <link rel="stylesheet" href="../assets/css/dashboard.css?v=2">
    <style>
        .question-card { border-radius: 12px; margin-bottom: 1.2rem; border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.07); }
        .question-card .card-header { border-radius: 12px 12px 0 0; font-weight: 600; }
        .answer-correct { background: #d1fae5; border-left: 4px solid #10b981; border-radius: 8px; padding: 10px 14px; }
        .answer-wrong   { background: #fee2e2; border-left: 4px solid #ef4444; border-radius: 8px; padding: 10px 14px; }
        .answer-label   { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; }
        .topic-badge    { font-size: 0.72rem; background: #ede9fe; color: #7c3aed; border-radius: 20px; padding: 3px 10px; }
        .score-card     { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border-radius: 16px; padding: 24px; }
    </style>
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
                <div>
                    <h3 class="mb-0 fw-bold"><i class="fa-solid fa-eye me-2 text-primary"></i>${attemptInfo.quizTitle}</h3>
                    <p class="text-muted mb-0">${attemptInfo.className} &nbsp;|&nbsp;
                        <c:choose>
                            <c:when test="${not empty attemptInfo.startTime}">
                                <fmt:formatDate value="${attemptInfo.startTime}" pattern="MMM dd, yyyy"/>
                            </c:when>
                            <c:otherwise>&mdash;</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <a href="history" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i>Back to History
                </a>
            </div>

            <!-- Score Summary -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="score-card">
                        <div class="fs-6 opacity-75">Your Score</div>
                        <div class="fs-1 fw-bold">${attemptInfo.totalScore}</div>
                        <div class="opacity-75">Total Marks</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-sm text-center p-3">
                        <div class="text-muted small">Accuracy</div>
                        <div class="fs-1 fw-bold ${attemptInfo.accuracy >= 70 ? 'text-success' : attemptInfo.accuracy >= 40 ? 'text-warning' : 'text-danger'}">${attemptInfo.accuracy}%</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-sm text-center p-3">
                        <div class="text-muted small">Questions</div>
                        <div class="fs-1 fw-bold text-primary">${reviewQuestionCount}</div>
                        <div class="text-muted small">Total Questions</div>
                    </div>
                </div>
            </div>

            <!-- Questions Review -->
            <h5 class="fw-bold mb-3"><i class="fa-solid fa-list-check me-2"></i>Question-by-Question Review</h5>

            <c:forEach var="q" items="${reviewData}" varStatus="status">
            <div class="card question-card">
                <div class="card-header d-flex justify-content-between align-items-center ${q.isCorrect ? 'bg-success bg-opacity-10 text-success' : 'bg-danger bg-opacity-10 text-danger'}">
                    <span>
                        <i class="fa-solid ${q.isCorrect ? 'fa-circle-check' : 'fa-circle-xmark'} me-2"></i>
                        Question ${status.index + 1}
                        <c:if test="${not empty q.topic}">
                            <span class="topic-badge ms-2">${q.topic}</span>
                        </c:if>
                    </span>
                    <span class="badge ${q.isCorrect ? 'bg-success' : 'bg-danger'}">${q.isCorrect ? '+' : '0'}${q.marks} mark</span>
                </div>
                <div class="card-body">
                    <p class="fw-medium mb-3">${q.questionText}</p>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="answer-label text-muted mb-1">Your Answer</div>
                            <div class="${q.isCorrect ? 'answer-correct' : 'answer-wrong'}">
                                <i class="fa-solid ${q.isCorrect ? 'fa-check text-success' : 'fa-xmark text-danger'} me-2"></i>
                                <c:choose>
                                    <c:when test="${not empty q.selectedAnswer}">${q.selectedAnswer}</c:when>
                                    <c:otherwise><em class="text-muted">Not answered</em></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <c:if test="${not q.isCorrect}">
                        <div class="col-md-6">
                            <div class="answer-label text-success mb-1">Correct Answer</div>
                            <div class="answer-correct">
                                <i class="fa-solid fa-check text-success me-2"></i>${q.correctAnswer}
                            </div>
                        </div>
                        </c:if>
                    </div>
                </div>
            </div>
            </c:forEach>

            <div class="text-center mt-3 mb-4">
                <a href="${pageContext.request.contextPath}/student/ai_analysis" class="btn btn-primary me-2">
                    <i class="fa-solid fa-brain me-2"></i>Get AI Analysis of Your Weak Topics
                </a>
                <a href="history" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i>Back to History
                </a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
