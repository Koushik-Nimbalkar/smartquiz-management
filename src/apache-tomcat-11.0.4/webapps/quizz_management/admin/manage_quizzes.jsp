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
    <title>Manage Quizzes | Smart Quiz</title>
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
                <li class="mt-5">
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
                </li>
            </ul>
        </nav>

        <div id="content">
            <div class="dashboard-nav">
                <div>
                    <h3 class="mb-0 fw-bold">Manage Quizzes</h3>
                    <p class="text-muted mb-0">Create, publish, and manage assessments</p>
                </div>
                <button class="btn btn-premium" data-bs-toggle="modal" data-bs-target="#createQuizModal">
                    <i class="fa-solid fa-plus me-2"></i>Create Quiz
                </button>
            </div>

            <div class="table-custom p-0">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Quiz Title</th>
                            <th>Class</th>
                            <th>Duration</th>
                            <th>Start Time</th>
                            <th>Status</th>
                            <th class="pe-4 text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty quizzes}">
                                <tr><td colspan="6" class="text-center text-muted py-4">No quizzes created yet. Click "Create Quiz" to get started.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="quiz" items="${quizzes}">
                                    <tr>
                                        <td class="ps-4 fw-medium">${quiz.title}</td>
                                        <td>${quiz.className}</td>
                                        <td>${quiz.durationMinutes} min</td>
                                        <td><fmt:formatDate value="${quiz.startTime}" pattern="MMM dd, yyyy HH:mm" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${quiz.published}">
                                                    <span class="badge bg-success bg-opacity-10 text-success px-2 py-1 rounded-pill">Published</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning bg-opacity-10 text-warning px-2 py-1 rounded-pill">Draft</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="pe-4 text-end">
                                            <c:choose>
                                                <c:when test="${quiz.published}">
                                                    <a href="manage_quizzes?action=unpublish&id=${quiz.id}" class="btn btn-sm btn-outline-warning" title="Unpublish"><i class="fa-solid fa-eye-slash"></i></a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="manage_quizzes?action=publish&id=${quiz.id}" class="btn btn-sm btn-outline-success" title="Publish"><i class="fa-solid fa-eye"></i></a>
                                                </c:otherwise>
                                            </c:choose>
                                            <button type="button" class="btn btn-sm btn-outline-info ms-1" title="Edit Quiz" 
                                                    onclick="openEditModal(${quiz.id}, '${quiz.title}', '${quiz.description}', ${quiz.classId}, ${quiz.durationMinutes}, '${quiz.startTime != null ? quiz.startTime.toString().substring(0, 16).replace(' ', 'T') : ''}', '${quiz.endTime != null ? quiz.endTime.toString().substring(0, 16).replace(' ', 'T') : ''}', ${quiz.randomizeQuestions}, ${quiz.negativeMarking}, ${quiz.published})">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </button>
                                            <a href="manage_questions?quizId=${quiz.id}" class="btn btn-sm btn-outline-primary ms-1" title="Manage Questions"><i class="fa-solid fa-list-check"></i></a>
                                            <a href="manage_quizzes?action=delete&id=${quiz.id}" class="btn btn-sm btn-outline-danger ms-1" title="Delete" onclick="return confirm('Delete this quiz?')"><i class="fa-solid fa-trash"></i></a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Create Quiz Modal -->
    <div class="modal fade" id="createQuizModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Create New Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="manage_quizzes" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Quiz Title</label>
                            <input type="text" class="form-control" name="title" required placeholder="e.g., Midterm Exam - Chapter 5">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="2" placeholder="Brief description of the quiz"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Class</label>
                                <select class="form-select" name="classId">
                                    <option value="">-- General (No class) --</option>
                                    <c:forEach var="cls" items="${classes}">
                                        <option value="${cls.id}">${cls.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" name="duration" value="30" min="5" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Start Time</label>
                                <input type="datetime-local" class="form-control" name="startTime">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">End Time</label>
                                <input type="datetime-local" class="form-control" name="endTime">
                            </div>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="randomize" id="randomize">
                            <label class="form-check-label" for="randomize">Randomize question order</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="negativeMarking" id="negativeMarking">
                            <label class="form-check-label" for="negativeMarking">Enable negative marking</label>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-premium">Create Quiz</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Quiz Modal -->
    <div class="modal fade" id="editQuizModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Edit Quiz</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="manage_quizzes" method="POST">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit_quiz_id">
                    <input type="hidden" name="published" id="edit_quiz_published">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Quiz Title</label>
                            <input type="text" class="form-control" name="title" id="edit_title" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" id="edit_description" rows="2"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Class</label>
                                <select class="form-select" name="classId" id="edit_classId">
                                    <option value="0">-- General (No class) --</option>
                                    <c:forEach var="cls" items="${classes}">
                                        <option value="${cls.id}">${cls.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" name="duration" id="edit_duration" min="5" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Start Time</label>
                                <input type="datetime-local" class="form-control" name="startTime" id="edit_startTime">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">End Time</label>
                                <input type="datetime-local" class="form-control" name="endTime" id="edit_endTime">
                            </div>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="randomize" id="edit_randomize">
                            <label class="form-check-label" for="edit_randomize">Randomize question order</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="negativeMarking" id="edit_negativeMarking">
                            <label class="form-check-label" for="edit_negativeMarking">Enable negative marking</label>
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
        function openEditModal(id, title, desc, classId, duration, startTime, endTime, rand, neg, pub) {
            document.getElementById('edit_quiz_id').value = id;
            document.getElementById('edit_title').value = title;
            document.getElementById('edit_description').value = desc !== 'null' ? desc : '';
            document.getElementById('edit_classId').value = classId;
            document.getElementById('edit_duration').value = duration;
            document.getElementById('edit_startTime').value = startTime !== 'null' ? startTime : '';
            document.getElementById('edit_endTime').value = endTime !== 'null' ? endTime : '';
            document.getElementById('edit_randomize').checked = rand;
            document.getElementById('edit_negativeMarking').checked = neg;
            if(pub) {
                document.getElementById('edit_quiz_published').value = 'true';
            } else {
                document.getElementById('edit_quiz_published').removeAttribute('value');
            }
            
            var editModal = new bootstrap.Modal(document.getElementById('editQuizModal'));
            editModal.show();
        }
    </script>
</body>
</html>
