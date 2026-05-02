<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="assets/css/style.css?v=2">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-card glass-card text-center animate-fade-in">
            <div class="bg-danger bg-opacity-10 text-danger rounded-circle d-inline-flex p-4 mb-3">
                <i class="fa-solid fa-lock fa-3x"></i>
            </div>
            <h3 class="fw-bold">Access Denied</h3>
            <p class="text-muted mb-4">You don't have permission to access this page.</p>
            <a href="login.jsp" class="btn btn-premium">Back to Login</a>
        </div>
    </div>
</body>
</html>
