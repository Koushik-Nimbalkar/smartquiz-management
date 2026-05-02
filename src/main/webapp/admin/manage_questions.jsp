<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Questions | ${quiz.title}</title>
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
                <li><a href="manage_classes"><i class="fa-solid fa-chalkboard-user"></i> Manage Classes</a></li>
                <li><a href="manage_students"><i class="fa-solid fa-users"></i> Students</a></li>
                <li class="active"><a href="manage_quizzes"><i class="fa-solid fa-file-pen"></i> Quizzes</a></li>
                <li><a href="reports"><i class="fa-solid fa-file-invoice"></i> Reports</a></li>
            </ul>
        </nav>

        <div id="content">
            <div class="dashboard-nav">
                <div>
                    <a href="manage_quizzes" class="text-decoration-none text-muted mb-2 d-inline-block small"><i class="fa-solid fa-arrow-left me-1"></i> Back to Quizzes</a>
                    <h3 class="mb-0 fw-bold">Questions for: ${quiz.title}</h3>
                    <p class="text-muted mb-0">Total Questions: ${questions.size()}</p>
                </div>
                <button class="btn btn-premium" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                    <i class="fa-solid fa-plus me-2"></i>Add Question
                </button>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty questions}">
                        <div class="col-12">
                            <div class="glass-card text-center py-5">
                                <i class="fa-solid fa-file-circle-question fa-3x text-muted mb-3"></i>
                                <h5>No questions yet</h5>
                                <p class="text-muted">Start adding questions to this assessment.</p>
                                <button class="btn btn-outline-primary rounded-pill mt-2" data-bs-toggle="modal" data-bs-target="#addQuestionModal">Add First Question</button>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="q" items="${questions}" varStatus="status">
                            <div class="col-12">
                                <div class="glass-card mb-0">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="fw-bold mb-0">Q${status.index + 1}. ${q.questionText}</h5>
                                        <div>
                                            <span class="badge bg-primary bg-opacity-10 text-primary me-2">${q.marks} Marks</span>
                                            <button type="button" class="btn btn-sm btn-outline-info" title="Edit Question" onclick='openEditQuestionModal(${q.id}, `${q.questionText.replace("`", "\\`")}`, ${q.marks}, ${q.negativeMarks}, `${q.topic.replace("`", "\\`")}`, [
                                                <c:forEach var="opt" items="${q.options}" varStatus="optStatus">
                                                    {text: `${opt.optionText.replace("`", "\\`")}`, isCorrect: ${opt.correct}}${not optStatus.last ? ',' : ''}
                                                </c:forEach>
                                            ])'><i class="fa-solid fa-pen-to-square"></i></button>
                                            <form action="manage_questions" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="quizId" value="${quizId}">
                                                <input type="hidden" name="questionId" value="${q.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete Question" onclick="return confirm('Are you sure you want to delete this question?');"><i class="fa-solid fa-trash"></i></button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="row g-2">
                                        <c:forEach var="opt" items="${q.options}">
                                            <div class="col-md-6">
                                                <div class="p-2 border rounded ${opt.correct ? 'bg-success bg-opacity-10 border-success' : 'bg-light'}">
                                                    <i class="fa-solid ${opt.correct ? 'fa-circle-check text-success' : 'fa-circle text-muted'} me-2"></i>
                                                    ${opt.optionText}
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <div class="mt-3 text-muted small">
                                        <span class="me-3"><i class="fa-solid fa-tag me-1"></i> Topic: ${q.topic}</span>
                                        <span><i class="fa-solid fa-circle-minus me-1 text-danger"></i> Neg. Marks: ${q.negativeMarks}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Add Question Modal -->
    <div class="modal fade" id="addQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Add New Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="manage_questions" method="POST">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="quizId" value="${quizId}">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Question Text</label>
                            <textarea class="form-control" name="questionText" rows="3" required placeholder="Enter the question..."></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Topic</label>
                                <input type="text" class="form-control" name="topic" placeholder="e.g., Physics">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Marks</label>
                                <input type="number" class="form-control" name="marks" value="1" min="1" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Negative Marks</label>
                                <input type="number" step="0.25" class="form-control" name="negativeMarks" value="0">
                            </div>
                        </div>
                        
                        <h6 class="fw-bold mt-3 mb-2">Options (Select the correct one)</h6>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" value="0" required checked>
                            <input type="text" class="form-control" name="optionText" required placeholder="Option 1">
                        </div>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" value="1">
                            <input type="text" class="form-control" name="optionText" required placeholder="Option 2">
                        </div>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" value="2">
                            <input type="text" class="form-control" name="optionText" placeholder="Option 3 (Optional)">
                        </div>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" value="3">
                            <input type="text" class="form-control" name="optionText" placeholder="Option 4 (Optional)">
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-premium">Save Question</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Question Modal -->
    <div class="modal fade" id="editQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Edit Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="manage_questions" method="POST">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="quizId" value="${quizId}">
                    <input type="hidden" name="questionId" id="edit_questionId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Question Text</label>
                            <textarea class="form-control" name="questionText" id="edit_questionText" rows="3" required></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Topic</label>
                                <input type="text" class="form-control" name="topic" id="edit_topic">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Marks</label>
                                <input type="number" class="form-control" name="marks" id="edit_marks" min="1" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Negative Marks</label>
                                <input type="number" step="0.25" class="form-control" name="negativeMarks" id="edit_negativeMarks">
                            </div>
                        </div>
                        
                        <h6 class="fw-bold mt-3 mb-2">Options (Select the correct one)</h6>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" id="edit_correct0" value="0" required>
                            <input type="text" class="form-control" name="optionText" id="edit_opt0" required placeholder="Option 1">
                        </div>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" id="edit_correct1" value="1">
                            <input type="text" class="form-control" name="optionText" id="edit_opt1" required placeholder="Option 2">
                        </div>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" id="edit_correct2" value="2">
                            <input type="text" class="form-control" name="optionText" id="edit_opt2" placeholder="Option 3 (Optional)">
                        </div>
                        <div class="mb-2 d-flex align-items-center">
                            <input class="form-check-input me-2" type="radio" name="correctOption" id="edit_correct3" value="3">
                            <input type="text" class="form-control" name="optionText" id="edit_opt3" placeholder="Option 4 (Optional)">
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-premium">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditQuestionModal(id, text, marks, negMarks, topic, options) {
            document.getElementById('edit_questionId').value = id;
            document.getElementById('edit_questionText').value = text;
            document.getElementById('edit_marks').value = marks;
            document.getElementById('edit_negativeMarks').value = negMarks;
            document.getElementById('edit_topic').value = topic !== 'null' ? topic : '';
            
            for(let i=0; i<4; i++) {
                let optInput = document.getElementById('edit_opt' + i);
                let correctRadio = document.getElementById('edit_correct' + i);
                if(i < options.length) {
                    optInput.value = options[i].text;
                    correctRadio.checked = options[i].isCorrect;
                } else {
                    optInput.value = '';
                    correctRadio.checked = false;
                }
            }
            
            var editModal = new bootstrap.Modal(document.getElementById('editQuestionModal'));
            editModal.show();
        }
    </script>
</body>
</html>
