<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="assets/css/style.css?v=3">
</head>
<body>
    <div class="auth-wrapper d-flex flex-column min-vh-100">
        <div class="flex-grow-1 d-flex align-items-center justify-content-center w-100 px-3 py-4">
        <div class="auth-card glass-card animate-fade-in">
            <div class="text-center mb-4">
                <a href="index.jsp" class="text-decoration-none">
                    <h2 class="navbar-brand mb-3"><i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz</h2>
                </a>
                <h4 class="fw-bold">Welcome Back</h4>
                <p class="text-muted">Enter your credentials to access your account</p>
            </div>
            
            <% 
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                if ("invalid_credentials".equals(error)) {
            %>
                <div class="alert alert-danger text-center"><i class="fa-solid fa-circle-exclamation me-2"></i>Invalid email or password.</div>
            <% } else if ("registered".equals(success)) { %>
                <div class="alert alert-success text-center"><i class="fa-solid fa-circle-check me-2"></i>Registration successful! Please login.</div>
            <% } else if ("logged_out".equals(success)) { %>
                <div class="alert alert-info text-center">You have been successfully logged out.</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth" method="POST">
                <input type="hidden" name="action" value="login">
                
                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-envelope text-muted"></i></span>
                        <input type="email" class="form-control border-start-0 ps-0" id="email" name="email" required placeholder="student@university.edu">
                    </div>
                </div>
                
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <label for="password" class="form-label mb-0">Password</label>
                        <a href="#" class="text-primary text-decoration-none small">Forgot Password?</a>
                    </div>
                    <div class="input-group mt-2">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
                        <input type="password" class="form-control border-start-0 ps-0" id="password" name="password" required placeholder="••••••••">
                    </div>
                </div>
                
                <button type="submit" class="btn btn-premium w-100 mb-3">Sign In</button>
            </form>
            
            <div class="text-center mt-3">
                <p class="text-muted mb-0">Don't have an account? <a href="register.jsp" class="text-primary fw-bold text-decoration-none">Sign up</a></p>
            </div>
        </div>
        </div>
        <footer class="text-center small text-muted pb-3 px-3 w-100 mt-auto">
            &copy; 2026 Smart Quiz Management System. All rights reserved.<br>
            <span class="fw-semibold text-secondary">Koushik-CSE@2026</span>
        </footer>
    </div>
</body>
</html>
