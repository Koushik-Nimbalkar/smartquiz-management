<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.smartquiz.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    if (request.getAttribute("topicPerformanceJson") == null) {
        request.setAttribute("topicPerformanceJson", "[]");
    }
    if (request.getAttribute("studentNameJsLiteral") == null) {
        request.setAttribute("studentNameJsLiteral", "\"\"");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Analysis | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
    <link rel="stylesheet" href="../assets/css/dashboard.css?v=2">
    <style>
        .ai-card { border-radius: 16px; border: none; box-shadow: 0 4px 16px rgba(99,102,241,0.12); }
        .ai-header { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border-radius: 16px 16px 0 0; padding: 20px 24px; }
        .topic-weak   { background: #fee2e2; border-left: 5px solid #ef4444; border-radius: 8px; padding: 12px 16px; margin-bottom: 10px; }
        .topic-medium { background: #fef3c7; border-left: 5px solid #f59e0b; border-radius: 8px; padding: 12px 16px; margin-bottom: 10px; }
        .topic-strong { background: #d1fae5; border-left: 5px solid #10b981; border-radius: 8px; padding: 12px 16px; margin-bottom: 10px; }
        .progress-custom { height: 10px; border-radius: 10px; }
        .ai-response { background: #f8faff; border-radius: 12px; padding: 20px; border: 1px solid #e0e7ff; line-height: 1.8; white-space: pre-wrap; font-family: 'Inter', sans-serif; }
        .typing-cursor::after { content: '▋'; animation: blink 1s infinite; }
        @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0} }
        .stat-pill { background: white; border-radius: 50px; padding: 6px 16px; font-size: 0.85rem; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    </style>
</head>
<body>
    <div class="wrapper">
        <nav id="sidebar">
            <div class="sidebar-header"><h4 class="navbar-brand mb-0 text-primary"><i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz</h4></div>
            <ul class="list-unstyled components">
                <li><a href="dashboard"><i class="fa-solid fa-chart-pie"></i> My Dashboard</a></li>
                <li><a href="available_quizzes"><i class="fa-solid fa-file-pen"></i> Available Quizzes</a></li>
                <li><a href="history"><i class="fa-solid fa-clock-rotate-left"></i> Quiz History</a></li>
                <li><a href="performance"><i class="fa-solid fa-chart-line"></i> Performance</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/student/ai_analysis"><i class="fa-solid fa-brain"></i> AI Analysis</a></li>
                <li class="mt-5"><a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
            </ul>
        </nav>
        <div id="content">
            <div class="dashboard-nav">
                <div>
                    <h3 class="mb-0 fw-bold"><i class="fa-solid fa-brain me-2 text-primary"></i>AI Performance Analysis</h3>
                    <p class="text-muted mb-0">Personalized insights powered by AI to help you improve</p>
                </div>
            </div>

            <!-- Topic Performance Cards -->
            <div class="row mb-4">
                <c:forEach var="t" items="${topicPerformance}">
                <div class="col-md-4 mb-3">
                    <div class="card border-0 shadow-sm h-100 p-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-semibold">${t.topic}</span>
                            <span class="badge ${t.accuracy >= 70 ? 'bg-success' : t.accuracy >= 40 ? 'bg-warning text-dark' : 'bg-danger'}">${t.accuracy}%</span>
                        </div>
                        <div class="progress progress-custom mb-2">
                            <div class="progress-bar ${t.accuracy >= 70 ? 'bg-success' : t.accuracy >= 40 ? 'bg-warning' : 'bg-danger'}" style="width:${t.accuracy}%"></div>
                        </div>
                        <small class="text-muted">${t.correctAnswers} / ${t.totalQuestions} correct</small>
                    </div>
                </div>
                </c:forEach>
                <c:if test="${empty topicPerformance}">
                <div class="col-12">
                    <div class="alert alert-info">
                        <i class="fa-solid fa-circle-info me-2"></i>
                        No quiz data yet. Complete some quizzes first to get AI analysis!
                    </div>
                </div>
                </c:if>
            </div>

            <!-- AI Analysis Box -->
            <c:if test="${not empty topicPerformance}">
            <div class="card ai-card mb-4">
                <div class="ai-header">
                    <h5 class="mb-1"><i class="fa-solid fa-sparkles me-2"></i>AI Smart Analysis</h5>
                    <p class="mb-0 opacity-75 small">Click the button below to get personalized recommendations</p>
                </div>
                <div class="card-body p-4">
                    <div id="aiResult" class="ai-response mb-3" style="display:none; min-height:120px;"></div>
                    <div id="aiPlaceholder" class="text-center py-4">
                        <i class="fa-solid fa-brain fa-3x text-primary opacity-25 mb-3 d-block"></i>
                        <p class="text-muted">Click "Analyze My Performance" to get AI-powered insights about your strengths, weaknesses, and what to study next.</p>
                    </div>
                    <div class="text-center">
                        <button id="analyzeBtn" class="btn btn-primary btn-lg px-5" onclick="runAiAnalysis()">
                            <i class="fa-solid fa-wand-magic-sparkles me-2"></i>Analyze My Performance
                        </button>
                    </div>
                </div>
            </div>
            </c:if>

            <!-- Recent Attempts Summary -->
            <c:if test="${not empty recentAttempts}">
            <h5 class="fw-bold mb-3"><i class="fa-solid fa-clock-rotate-left me-2"></i>Recent Quiz Performance</h5>
            <div class="table-custom p-0 mb-4">
                <table class="table table-hover mb-0">
                    <thead><tr><th class="ps-4">Quiz</th><th>Score</th><th>Accuracy</th></tr></thead>
                    <tbody>
                        <c:forEach var="a" items="${recentAttempts}">
                        <tr>
                            <td class="ps-4">${a.quizTitle}</td>
                            <td>${a.score}</td>
                            <td><span class="badge ${a.accuracy >= 70 ? 'bg-success' : a.accuracy >= 40 ? 'bg-warning text-dark' : 'bg-danger'} bg-opacity-10 ${a.accuracy >= 70 ? 'text-success' : a.accuracy >= 40 ? 'text-warning' : 'text-danger'}">${a.accuracy}%</span></td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            </c:if>
        </div>
    </div>

    <!-- Topic data serialized on server -->
    <script>
        const aiReportData = `${aiReport.replace('`', '\\`').replace('$', '\\$')}`;

        function runAiAnalysis() {
            const btn = document.getElementById('analyzeBtn');
            const resultDiv = document.getElementById('aiResult');
            const placeholder = document.getElementById('aiPlaceholder');

            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-2"></i>Processing Neural Data...';
            placeholder.style.display = 'none';
            resultDiv.style.display = 'block';
            resultDiv.innerHTML = '<span class="text-muted typing-cursor">Synthesizing personalized analysis...</span>';

            try {
                // Formatting the markdown-like report for simple HTML display
                const formattedReport = aiReportData
                    .replace(/### (.*)/g, '<h5 class="fw-bold mt-3 mb-2 text-primary">$1</h5>')
                    .replace(/\*\* (.*?) \*\*/g, '<strong>$1</strong>')
                    .replace(/- \*\*(.*?)\*\*/g, '<li><strong>$1</strong>')
                    .replace(/- /g, '<li>')
                    .replace(/\n/g, '<br>');

                resultDiv.innerHTML = '';
                let i = 0;
                // Faster typing for pre-generated content
                const interval = setInterval(() => {
                    // Find next tag or character
                    if (formattedReport[i] === '<') {
                        let tagEnd = formattedReport.indexOf('>', i);
                        resultDiv.innerHTML += formattedReport.substring(i, tagEnd + 1);
                        i = tagEnd + 1;
                    } else {
                        resultDiv.innerHTML += formattedReport.charAt(i);
                        i++;
                    }
                    
                    if (i >= formattedReport.length) {
                        clearInterval(interval);
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles me-2"></i>Refresh Analysis';
                        // Add a fade-in for the lists to look better
                        resultDiv.innerHTML = resultDiv.innerHTML.replace(/<li>/g, '<li class="animate-fade-in" style="list-style: none;"><i class="fa-solid fa-chevron-right me-2 text-primary small"></i>');
                    }
                }, 5);
            } catch (err) {
                console.error(err);
                resultDiv.innerHTML = '<div class="alert alert-danger">The neural link was interrupted. Please try again.</div>';
                btn.disabled = false;
                btn.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles me-2"></i>Retry Analysis';
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
