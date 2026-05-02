<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="assets/css/style.css?v=3">
</head>
<body>
    <div class="auth-wrapper d-flex flex-column min-vh-100">
        <div class="flex-grow-1 d-flex align-items-center justify-content-center w-100 px-3 py-4">
        <div class="auth-card glass-card animate-fade-in" style="max-width: 500px;">
            <div class="text-center mb-4">
                <a href="index.jsp" class="text-decoration-none">
                    <h2 class="navbar-brand mb-3"><i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz</h2>
                </a>
                <h4 class="fw-bold">Create an Account</h4>
                <p class="text-muted">Join the next-generation learning platform</p>
            </div>
            
            <% 
                String error = request.getParameter("error");
                if ("email_taken".equals(error)) {
            %>
                <div class="alert alert-danger text-center"><i class="fa-solid fa-circle-exclamation me-2"></i>Email is already registered. Please login.</div>
            <% } else if ("registration_failed".equals(error)) { %>
                <div class="alert alert-danger text-center"><i class="fa-solid fa-circle-exclamation me-2"></i>Registration failed. Please try again later.</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/auth" method="POST">
                <input type="hidden" name="action" value="register">
                
                <div class="mb-3">
                    <label for="name" class="form-label">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-user text-muted"></i></span>
                        <input type="text" class="form-control border-start-0 ps-0" id="name" name="name" required placeholder="Enter your full name">
                    </div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-envelope text-muted"></i></span>
                        <input type="email" class="form-control border-start-0 ps-0" id="email" name="email" required placeholder="student@university.edu">
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
                        <input type="password" class="form-control border-start-0 ps-0" id="password" name="password" required placeholder="••••••••">
                    </div>
                </div>

                <div class="mb-4">
                    <label for="role" class="form-label">I am a</label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="STUDENT" selected>Student</option>
                        <option value="FACULTY">Faculty / Educator</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-premium w-100 mb-3">Sign Up</button>
            </form>
            
            <div class="text-center mt-3">
                <p class="text-muted mb-0">Already have an account? <a href="login.jsp" class="text-primary fw-bold text-decoration-none">Sign in</a></p>
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
