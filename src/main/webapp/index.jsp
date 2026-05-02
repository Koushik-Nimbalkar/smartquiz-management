<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Quiz | Quiz Generation & Learning</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="assets/css/style.css?v=3">
</head>
<body class="d-flex flex-column min-vh-100">

    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-lg-center">
                    <li class="nav-item"><a class="nav-link" href="#generate">Quiz generation</a></li>
                    <li class="nav-item"><a class="nav-link" href="#features">Highlights</a></li>
                    <li class="nav-item"><a class="nav-link" href="#how">How it works</a></li>
                    <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                        <a class="btn btn-outline-primary rounded-pill px-4 w-100 w-lg-auto" href="login.jsp">Login</a>
                    </li>
                    <li class="nav-item ms-lg-2 mt-2 mt-lg-0">
                        <a class="btn btn-premium w-100 w-lg-auto" href="register.jsp">Get started</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <main class="flex-grow-1">
        <section class="hero-section">
            <div class="container">
                <div class="row justify-content-center text-center">
                    <div class="col-lg-8 animate-fade-in">
                        <span class="landing-badge"><i class="fa-solid fa-wand-magic-sparkles"></i> Quiz generation made simple</span>
                        <h1 class="hero-text">Build quizzes in minutes. Watch learning come alive.</h1>
                        <p class="hero-subtext">Design objective quizzes, assign them to classes, and get instant scores—plus smart insights so students know what to revise next.</p>
                        <div class="d-flex flex-wrap justify-content-center gap-2 gap-sm-3">
                            <a href="register.jsp" class="btn btn-premium btn-lg">Create your first quiz</a>
                            <a href="#generate" class="btn btn-outline-secondary btn-lg rounded-pill px-4">See what you can build</a>
                        </div>
                        <div class="mt-4 pt-2 d-flex flex-wrap justify-content-center align-items-center gap-3 gap-md-4">
                            <div class="d-flex align-items-center gap-2 text-muted small">
                                <span class="text-success"><i class="fa-solid fa-circle-check"></i></span>
                                MCQ &amp; timed attempts
                            </div>
                            <div class="d-flex align-items-center gap-2 text-muted small">
                                <span class="text-primary"><i class="fa-solid fa-layer-group"></i></span>
                                Class codes &amp; enrollments
                            </div>
                            <div class="d-flex align-items-center gap-2 text-muted small">
                                <span class="text-warning"><i class="fa-solid fa-brain"></i></span>
                                Topic &amp; AI-style analysis
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="generate" class="py-5 bg-white border-top border-light">
            <div class="container py-4">
                <div class="row align-items-center g-4">
                    <div class="col-lg-5">
                        <h2 class="fw-bold mb-3">Quiz generation that fits your syllabus</h2>
                        <p class="text-muted mb-4">Stack questions by topic, set windows for when a quiz opens, and let the system handle scoring—you focus on teaching, not spreadsheets.</p>
                        <ul class="list-unstyled mb-0">
                            <li class="d-flex gap-3 mb-3"><i class="fa-solid fa-circle-plus text-primary mt-1"></i><span><strong>Flexible items</strong> — build MCQ sets quickly and reuse them across classes.</span></li>
                            <li class="d-flex gap-3 mb-3"><i class="fa-solid fa-shield-heart text-danger mt-1"></i><span><strong>Fair attempts</strong> — timed sessions help keep assessments consistent.</span></li>
                            <li class="d-flex gap-3"><i class="fa-solid fa-wand-magic-sparkles text-warning mt-1"></i><span><strong>Deeper feedback</strong> — students see history, review, and topic breakdowns.</span></li>
                        </ul>
                    </div>
                    <div class="col-lg-7">
                        <div class="row g-3">
                            <div class="col-sm-6">
                                <div class="glass-card h-100 border-0 shadow-sm p-4" style="background: linear-gradient(145deg, #eef2ff, #ffffff);">
                                    <i class="fa-solid fa-diagram-project fa-2x text-primary mb-3"></i>
                                    <h5 class="fw-bold">Structured flow</h5>
                                    <p class="small text-muted mb-0">Class → Quiz → Attempt → Score. One clear path from creation to insight.</p>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="glass-card h-100 border-0 shadow-sm p-4" style="background: linear-gradient(145deg, #ecfdf5, #ffffff);">
                                    <i class="fa-solid fa-gauge-high fa-2x text-success mb-3"></i>
                                    <h5 class="fw-bold">At-a-glance health</h5>
                                    <p class="small text-muted mb-0">Dashboards for faculty and learners—see who needs help before the midterm.</p>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="glass-card border-0 shadow-sm p-4 d-flex flex-wrap align-items-center justify-content-between gap-3" style="background: #f8fafc;">
                                    <div>
                                        <h6 class="fw-bold mb-1"><i class="fa-solid fa-pen-ruler text-primary me-2"></i>Worth showing in a demo</h6>
                                        <p class="small text-muted mb-0">Open <strong>Register</strong>, create a class code, publish a quiz, and take it as a student—full loop.</p>
                                    </div>
                                    <a href="register.jsp" class="btn btn-premium rounded-pill shrink-0">Try the flow</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="features" class="py-5 section-soft">
            <div class="container py-5">
                <div class="text-center mb-5">
                    <h2 class="fw-bold">Why teams pick SmartQuiz</h2>
                    <p class="text-muted mx-auto" style="max-width: 540px;">Quizzes aren’t only tests—they’re signals. Generate them fast, ship them confidently, and read the patterns.</p>
                </div>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="glass-card h-100 text-center p-4 border-0 shadow-sm" style="background: #ffffff;">
                            <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex p-4 mb-3">
                                <i class="fa-solid fa-file-circle-plus fa-2x"></i>
                            </div>
                            <h4>Quiz generation</h4>
                            <p class="text-muted mb-0">Author question banks, attach quizzes to classes, and control when they go live.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card h-100 text-center p-4 border-0 shadow-sm" style="background: #ffffff;">
                            <div class="bg-success bg-opacity-10 text-success rounded-circle d-inline-flex p-4 mb-3">
                                <i class="fa-solid fa-chart-pie fa-2x"></i>
                            </div>
                            <h4>Performance signals</h4>
                            <p class="text-muted mb-0">Scores, history, and topic views help both sides see what’s clicking—and what isn’t.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card h-100 text-center p-4 border-0 shadow-sm" style="background: #ffffff;">
                            <div class="bg-warning bg-opacity-10 text-warning rounded-circle d-inline-flex p-4 mb-3">
                                <i class="fa-solid fa-shield-halved fa-2x"></i>
                            </div>
                            <h4>Focused sessions</h4>
                            <p class="text-muted mb-0">Built for fair, timed attempts so assessment matches the classroom experience.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="how" class="py-5 bg-white">
            <div class="container py-4">
                <h2 class="fw-bold text-center mb-5">How it works</h2>
                <div class="row g-4 landing-steps text-center text-md-start">
                    <div class="col-md-4">
                        <div class="glass-card h-100 p-4 border-0 shadow-sm">
                            <span class="step-num">1</span>
                            <h5 class="fw-bold">Sign up &amp; create a class</h5>
                            <p class="text-muted small mb-0">Faculty gets a code; students join in one step.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card h-100 p-4 border-0 shadow-sm">
                            <span class="step-num">2</span>
                            <h5 class="fw-bold">Generate &amp; schedule a quiz</h5>
                            <p class="text-muted small mb-0">Add MCQs, set timing, and assign to the right cohort.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card h-100 p-4 border-0 shadow-sm">
                            <span class="step-num">3</span>
                            <h5 class="fw-bold">Learn from the results</h5>
                            <p class="text-muted small mb-0">Instant scores, review, and topic insight for continuous improvement.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="site-footer bg-dark text-white py-4 mt-auto">
        <div class="container">
            <div class="row align-items-center justify-content-between gy-3 text-center text-md-start">
                <div class="col-md-auto">
                    <p class="footer-brand mb-1"><i class="fa-solid fa-graduation-cap me-2"></i>SmartQuiz</p>
                    <p class="small text-white-50 mb-0">Quiz generation, delivery, and learning insights.</p>
                </div>
                <div class="col-md-auto small text-white-50">
                    <p class="mb-1">&copy; 2026 Smart Quiz Management System. All rights reserved.</p>
                    <p class="mb-0"><span class="text-white fw-semibold">Koushik-CSE@2026</span></p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
