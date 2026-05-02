<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.smartquiz.models.User" %>
<%@ page import="com.smartquiz.models.Quiz" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"STUDENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    if (quiz == null) {
        response.sendRedirect(request.getContextPath() + "/student/available_quizzes"); return;
    }
    long endTime = System.currentTimeMillis() + (quiz.getDurationMinutes() * 60 * 1000L);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attempting Quiz | Smart Quiz</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css?v=2" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css?v=2">
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
    <style>
        body { background-color: #f1f5f9; user-select: none; }
        .quiz-header { background: #fff; border-bottom: 1px solid #e2e8f0; position: sticky; top: 0; z-index: 1000; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .question-card { background: #fff; border-radius: 12px; padding: 24px; margin-bottom: 24px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .question-option { position: relative; display: flex; align-items: center; padding: 12px 16px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 12px; cursor: pointer; transition: all 0.2s; }
        .question-option:hover { background: #f8fafc; border-color: #cbd5e1; }
        .question-option:has(input[type="radio"]:checked) { background: rgba(79, 70, 229, 0.05); border-color: var(--primary); }
        .palette-container { background: #fff; border-radius: 12px; padding: 20px; border: 1px solid #e2e8f0; position: sticky; top: 90px; }
        .palette-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; }
        .palette-btn { width: 100%; aspect-ratio: 1; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-weight: 600; }
    </style>
</head>
<body>
    <div id="fullscreenOverlay" class="position-fixed top-0 start-0 w-100 h-100 d-flex flex-column align-items-center justify-content-center z-3" style="background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab); background-size: 400% 400%; animation: gradientBG 15s ease infinite;">
        <div class="glass-card text-center animate-fade-in" style="max-width: 500px; padding: 3rem;">
            <div class="mb-4">
                <i class="fa-solid fa-graduation-cap fa-4x text-primary mb-3" style="filter: drop-shadow(0 0 10px rgba(255,255,255,0.8));"></i>
            </div>
            <h2 class="fw-bold mb-4 text-dark">Ready to begin?</h2>
            <p class="fs-5 text-dark mb-2"><strong>${quiz.title}</strong></p>
            <p class="text-dark mb-4 opacity-75">Duration: ${quiz.durationMinutes} minutes | ${questions.size()} questions</p>
            <button id="startExamBtn" class="btn btn-premium btn-lg w-100 py-3 fs-5">
                <i class="fa-solid fa-play me-2"></i>Start Exam
            </button>
            <p class="mt-4 small text-dark opacity-50"><i class="fa-solid fa-shield-halved me-1"></i> This exam is monitored. Do not switch tabs.</p>
        </div>
    </div>

    <div class="quiz-header py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0 fw-bold">${quiz.title}</h4>
                <p class="text-muted small mb-0">Student: <%= user.getName() %></p>
            </div>
            <div class="d-flex align-items-center gap-4">
                <div id="timerBadge" class="badge bg-primary fs-5 px-3 py-2 rounded-pill shadow-sm">
                    <i class="fa-solid fa-clock me-2"></i><span id="timerDisplay">--:--:--</span>
                </div>
            </div>
        </div>
    </div>

    <div class="container py-4">
        <form id="quizForm" action="${pageContext.request.contextPath}/student/submit_quiz" method="POST">
            <input type="hidden" name="attemptId" value="${attemptId}">
            <input type="hidden" name="quizId" value="${quiz.id}">
            <input type="hidden" name="tabSwitches" id="tabSwitchesInput" value="0">
            <input type="hidden" name="cheatingFlags" id="cheatingFlagsInput" value="false">
            <div class="row">
                <div class="col-lg-8">
                    <c:forEach var="question" items="${questions}" varStatus="loop">
                        <div class="question-card" data-question="${loop.index + 1}">
                            <div class="d-flex justify-content-between mb-3">
                                <h5 class="fw-bold">Question ${loop.index + 1} <span class="badge bg-light text-dark border ms-2">${question.marks} Mark(s)</span></h5>
                            </div>
                            <p class="fs-5 mb-4">${question.questionText}</p>
                            <c:forEach var="opt" items="${question.options}">
                                <div class="question-option">
                                    <input class="form-check-input me-3 mt-0" type="radio" name="q_${question.id}" id="opt_${opt.id}" value="${opt.id}">
                                    <label class="form-check-label w-100 stretched-link" for="opt_${opt.id}">${opt.optionText}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </c:forEach>
                    <div class="text-center mt-4">
                        <p class="text-muted small"><i class="fa-solid fa-circle-info me-1"></i>End of questions.</p>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="palette-container shadow-sm">
                        <h5 class="fw-bold mb-3 border-bottom pb-2">Question Palette</h5>
                        <div class="palette-grid mb-4">
                            <c:forEach var="q" items="${questions}" varStatus="loop">
                                <button type="button" class="btn btn-outline-secondary palette-btn" data-question="${loop.index + 1}">${loop.index + 1}</button>
                            </c:forEach>
                        </div>
                        <hr>
                        <button type="button" class="btn btn-premium w-100 mt-2 py-3 fs-5" onclick="confirmSubmit()">
                            <i class="fa-solid fa-paper-plane me-2"></i>Submit Exam
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ======= STATE =======
        let tabSwitches = 0;
        const maxSwitches = 3;
        let isExamActive = false;
        let isAutoSubmitting = false;
        let isSubmitting = false;   // Set true before ANY confirm() to silence blur
        let blurDebounce = null;    // Prevent blur + visibilitychange double-counting

        // ======= START EXAM =======
        document.getElementById('startExamBtn').addEventListener('click', () => {
            const overlay = document.getElementById('fullscreenOverlay');

            // Hide overlay FIRST so exam is always accessible even if fullscreen fails
            overlay.classList.remove('d-flex');
            overlay.classList.add('d-none');
            isExamActive = true;
            startTimer(<%= endTime %>);

            // Request fullscreen (best-effort, does not block the exam)
            const elem = document.documentElement;
            const requestFS = elem.requestFullscreen
                            || elem.webkitRequestFullscreen
                            || elem.mozRequestFullScreen
                            || elem.msRequestFullscreen;
            if (requestFS) {
                requestFS.call(elem).catch(err => {
                    console.warn("Fullscreen request failed (may be blocked by browser):", err);
                });
            }
        });

        // ======= FULLSCREEN EXIT DETECTION =======
        document.addEventListener('fullscreenchange', handleFullscreenChange);
        document.addEventListener('webkitfullscreenchange', handleFullscreenChange);

        function handleFullscreenChange() {
            const isFullscreen = !!(document.fullscreenElement || document.webkitFullscreenElement);
            if (!isFullscreen && isExamActive && !isAutoSubmitting && !isSubmitting) {
                tabSwitches++;
                updateCheatingStats();
                if (tabSwitches < maxSwitches) {
                    isSubmitting = true;
                    alert("⚠️ WARNING: Full-screen exited — Violation " + tabSwitches + "/" + maxSwitches + ".\nPlease stay in full-screen mode or your exam will be auto-submitted.");
                    isSubmitting = false;
                    // Re-enter fullscreen
                    const elem = document.documentElement;
                    const requestFS = elem.requestFullscreen || elem.webkitRequestFullscreen;
                    if (requestFS) requestFS.call(elem).catch(() => {});
                } else {
                    triggerAutoSubmit("Too many full-screen exits.");
                }
            }
        }

        // ======= TAB / WINDOW FOCUS DETECTION =======
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) onFocusLost("tab-switch");
        });

        window.addEventListener('blur', () => {
            // Only handle blur if visibilitychange hasn't already fired for this event
            if (!document.hidden) onFocusLost("window-blur");
        });

        function onFocusLost(source) {
            if (!isExamActive || isAutoSubmitting || isSubmitting) return;
            // Debounce: ignore if already handled within 200ms
            if (blurDebounce) return;
            blurDebounce = setTimeout(() => { blurDebounce = null; }, 200);

            tabSwitches++;
            updateCheatingStats();
            if (tabSwitches >= maxSwitches) {
                triggerAutoSubmit("Excessive tab switching detected.");
            } else {
                isSubmitting = true;
                alert("⚠️ WARNING: Tab switching is not allowed — Violation " + tabSwitches + "/" + maxSwitches + ".\nYour exam will be auto-submitted on the next violation.");
                isSubmitting = false;
            }
        }

        function updateCheatingStats() {
            document.getElementById('tabSwitchesInput').value = tabSwitches;
            if (tabSwitches >= maxSwitches) {
                document.getElementById('cheatingFlagsInput').value = "true";
            }
        }

        function triggerAutoSubmit(reason) {
            if (isAutoSubmitting) return;
            isAutoSubmitting = true;
            isExamActive = false;
            document.getElementById('cheatingFlagsInput').value = "true";
            isSubmitting = true;
            alert("🚫 AUTO-SUBMITTING: " + reason + "\nYour attempt has been recorded for review.");
            isSubmitting = false;
            document.getElementById('quizForm').submit();
        }

        // ======= TIMER =======
        function startTimer(endTime) {
            const timerDisplay = document.getElementById('timerDisplay');
            const timerBadge = document.getElementById('timerBadge');
            const interval = setInterval(() => {
                const remaining = endTime - Date.now();
                if (remaining <= 0) {
                    clearInterval(interval);
                    if (!isAutoSubmitting && !isSubmitting) {
                        isExamActive = false;
                        document.getElementById('quizForm').submit();
                    }
                    return;
                }
                const h = Math.floor(remaining / 3600000);
                const m = Math.floor((remaining % 3600000) / 60000);
                const s = Math.floor((remaining % 60000) / 1000);
                timerDisplay.textContent =
                    String(h).padStart(2,'0') + ':' +
                    String(m).padStart(2,'0') + ':' +
                    String(s).padStart(2,'0');
                if (remaining < 300000) {
                    timerBadge.className = 'badge bg-danger fs-5 px-3 py-2 rounded-pill shadow-sm';
                }
            }, 1000);
        }

        // ======= MANUAL SUBMIT =======
        function confirmSubmit() {
            if (isAutoSubmitting) return;
            isSubmitting = true;   // silence blur/visibility events during confirm dialog
            const ok = confirm("Are you sure you want to submit the exam?");
            isSubmitting = false;
            if (ok) {
                isExamActive = false;
                isAutoSubmitting = true;  // prevent double-submit
                document.getElementById('quizForm').submit();
            }
        }

        // ======= QUESTION PALETTE =======
        document.querySelectorAll('input[type="radio"]').forEach(input => {
            input.addEventListener('change', () => {
                const card = input.closest('.question-card');
                const qNum = card.dataset.question;
                const btn = document.querySelector('.palette-btn[data-question="' + qNum + '"]');
                if (btn) {
                    btn.classList.remove('btn-outline-secondary');
                    btn.classList.add('btn-success', 'text-white');
                }
            });
        });

        document.querySelectorAll('.palette-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const qNum = btn.dataset.question;
                const targetCard = document.querySelector('.question-card[data-question="' + qNum + '"]');
                if (targetCard) {
                    const headerOffset = 100;
                    const offsetPosition = targetCard.getBoundingClientRect().top + window.pageYOffset - headerOffset;
                    window.scrollTo({ top: offsetPosition, behavior: 'smooth' });
                }
            });
        });
    </script>
</body>
</html>
