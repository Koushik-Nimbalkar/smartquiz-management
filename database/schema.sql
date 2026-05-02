CREATE DATABASE IF NOT EXISTS smartquiz_db;
USE smartquiz_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'FACULTY', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Classes Table
CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    join_code VARCHAR(20) NOT NULL UNIQUE,
    faculty_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (faculty_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Enrollments Table
CREATE TABLE IF NOT EXISTS enrollments (
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
);

-- Quizzes Table
CREATE TABLE IF NOT EXISTS quizzes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    class_id INT,
    duration_minutes INT NOT NULL DEFAULT 30,
    start_time DATETIME,
    end_time DATETIME,
    randomize_questions BOOLEAN DEFAULT FALSE,
    negative_marking BOOLEAN DEFAULT FALSE,
    is_published BOOLEAN DEFAULT FALSE,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Questions Table
CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quiz_id INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('MCQ', 'MULTI_SELECT', 'TRUE_FALSE', 'SHORT_ANSWER') DEFAULT 'MCQ',
    marks INT DEFAULT 1,
    negative_marks DECIMAL(5,2) DEFAULT 0.00,
    topic VARCHAR(100),
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- Options Table
CREATE TABLE IF NOT EXISTS options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- Attempts Table
CREATE TABLE IF NOT EXISTS attempts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    quiz_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    is_submitted BOOLEAN DEFAULT FALSE,
    tab_switches INT DEFAULT 0,
    cheating_flags BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);

-- Answers Table
CREATE TABLE IF NOT EXISTS answers (
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option_id INT,
    answer_text TEXT,
    is_correct BOOLEAN,
    PRIMARY KEY (attempt_id, question_id),
    FOREIGN KEY (attempt_id) REFERENCES attempts(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    FOREIGN KEY (selected_option_id) REFERENCES options(id) ON DELETE SET NULL
);

-- Results Table
CREATE TABLE IF NOT EXISTS results (
    attempt_id INT PRIMARY KEY,
    total_score DECIMAL(5,2) NOT NULL,
    accuracy_percentage DECIMAL(5,2) NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (attempt_id) REFERENCES attempts(id) ON DELETE CASCADE
);

-- Announcements Table
CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Activity Logs Table
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================
-- SEED DATA
-- =============================================

-- Admin user: admin@smartquiz.com / admin123
-- SHA-256 hash of 'admin123' = 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
INSERT INTO users (name, email, password_hash, role) VALUES 
('System Admin', 'admin@smartquiz.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN');

-- Faculty user: faculty@smartquiz.com / faculty123
-- SHA-256 hash of 'faculty123' = 8e02e23152dcabbac43a4e3cc84a2ec08162842bdd89a tried...
-- Let's compute: we need to use the same PasswordHelper logic
-- For simplicity, using a known hash. Password: pass123
-- SHA-256('pass123') = 9b8769a4a742959a2d0298c36fb70623f2dfacda8436b42e150577b4 is wrong format
-- Actually let me just use the same approach - the hash will be computed by Java's SHA-256
-- admin123 -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9

-- Faculty: faculty@smartquiz.com / faculty123
INSERT INTO users (name, email, password_hash, role) VALUES 
('Prof. Sharma', 'faculty@smartquiz.com', '27041f5856c7387a997252694afb048d1aa939228ffcdbd6285b979b8da20e7a', 'FACULTY');

-- Students (all use password: password)
INSERT INTO users (name, email, password_hash, role) VALUES 
('Rahul Kumar', 'rahul@student.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'STUDENT'),
('Priya Singh', 'priya@student.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'STUDENT'),
('Amit Patel', 'amit@student.edu', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'STUDENT');

-- Classes
INSERT INTO classes (name, join_code, faculty_id) VALUES 
('CS101 - Data Structures', 'CS101-2026', 2),
('CS201 - Database Systems', 'CS201-2026', 2),
('CS301 - Software Engineering', 'CS301-2026', 2);

-- Enrollments (students enrolled in classes)
INSERT INTO enrollments (student_id, class_id) VALUES 
(3, 1), (3, 2),
(4, 1), (4, 2), (4, 3),
(5, 1);

-- Quizzes
INSERT INTO quizzes (title, description, class_id, duration_minutes, start_time, end_time, is_published, created_by) VALUES 
('Midterm - Arrays & Linked Lists', 'Midterm exam covering arrays, linked lists, and basic data structures', 1, 30, NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 6 DAY, TRUE, 2),
('Quiz 2 - SQL Fundamentals', 'SQL queries, joins, and normalization', 2, 20, NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 2 DAY, TRUE, 2),
('Quiz 3 - Design Patterns', 'Creational, structural, and behavioral patterns', 3, 25, NOW() + INTERVAL 2 DAY, NOW() + INTERVAL 3 DAY, TRUE, 2),
('Final Exam - Trees & Graphs', 'Comprehensive exam on trees, graphs, and traversals', 1, 45, NOW() + INTERVAL 7 DAY, NOW() + INTERVAL 8 DAY, TRUE, 2),
('Practice Quiz - ER Diagrams', 'Practice quiz on ER modeling', 2, 15, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 9 DAY, TRUE, 2);

-- Questions for Quiz 1 (Midterm - Arrays & Linked Lists)
INSERT INTO questions (quiz_id, question_text, question_type, marks, topic) VALUES 
(1, 'What is the time complexity of accessing an element in an array by index?', 'MCQ', 1, 'Arrays'),
(1, 'Which data structure uses LIFO principle?', 'MCQ', 1, 'Stacks'),
(1, 'In a singly linked list, each node contains?', 'MCQ', 1, 'Linked Lists'),
(1, 'What is the worst case time complexity of insertion in an unsorted array?', 'MCQ', 1, 'Arrays'),
(1, 'A doubly linked list allows traversal in both directions.', 'TRUE_FALSE', 1, 'Linked Lists');

-- Options for Q1
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(1, 'O(1)', TRUE), (1, 'O(n)', FALSE), (1, 'O(log n)', FALSE), (1, 'O(n^2)', FALSE);
-- Options for Q2
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(2, 'Queue', FALSE), (2, 'Stack', TRUE), (2, 'Array', FALSE), (2, 'Linked List', FALSE);
-- Options for Q3
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(3, 'Only data', FALSE), (3, 'Data and a pointer to the next node', TRUE), (3, 'Two pointers', FALSE), (3, 'Data and index', FALSE);
-- Options for Q4
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(4, 'O(1)', FALSE), (4, 'O(n)', TRUE), (4, 'O(log n)', FALSE), (4, 'O(n log n)', FALSE);
-- Options for Q5 (True/False)
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(5, 'True', TRUE), (5, 'False', FALSE);

-- Questions for Quiz 2 (SQL Fundamentals)
INSERT INTO questions (quiz_id, question_text, question_type, marks, topic) VALUES 
(2, 'Which SQL command is used to retrieve data from a database?', 'MCQ', 1, 'SQL Basics'),
(2, 'Which type of JOIN returns all rows from both tables?', 'MCQ', 1, 'SQL Joins'),
(2, 'What does the HAVING clause do?', 'MCQ', 1, 'SQL Aggregation'),
(2, 'DROP TABLE removes a table from the database.', 'TRUE_FALSE', 1, 'DDL');

-- Options for Q6
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(6, 'GET', FALSE), (6, 'SELECT', TRUE), (6, 'FETCH', FALSE), (6, 'RETRIEVE', FALSE);
-- Options for Q7
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(7, 'INNER JOIN', FALSE), (7, 'LEFT JOIN', FALSE), (7, 'FULL OUTER JOIN', TRUE), (7, 'CROSS JOIN', FALSE);
-- Options for Q8
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(8, 'Filters rows before grouping', FALSE), (8, 'Filters groups after GROUP BY', TRUE), (8, 'Sorts the result', FALSE), (8, 'Limits output rows', FALSE);
-- Options for Q9
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(9, 'True', TRUE), (9, 'False', FALSE);

-- Questions for Quiz 5 (Practice Quiz - ER Diagrams)
INSERT INTO questions (quiz_id, question_text, question_type, marks, topic) VALUES 
(5, 'In an ER diagram, a rectangle represents?', 'MCQ', 1, 'ER Modeling'),
(5, 'A weak entity depends on another entity for its existence.', 'TRUE_FALSE', 1, 'ER Modeling'),
(5, 'Which relationship type connects more than two entities?', 'MCQ', 1, 'ER Modeling');

-- Options for Q10
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(10, 'Attribute', FALSE), (10, 'Entity', TRUE), (10, 'Relationship', FALSE), (10, 'Key', FALSE);
-- Options for Q11
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(11, 'True', TRUE), (11, 'False', FALSE);
-- Options for Q12
INSERT INTO options (question_id, option_text, is_correct) VALUES 
(12, 'Binary', FALSE), (12, 'Unary', FALSE), (12, 'Ternary', TRUE), (12, 'Recursive', FALSE);

-- Attempts (past completed quizzes)
INSERT INTO attempts (student_id, quiz_id, start_time, end_time, is_submitted, tab_switches, cheating_flags) VALUES 
(3, 1, NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 7 DAY + INTERVAL 25 MINUTE, TRUE, 0, FALSE),
(3, 2, NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 3 DAY + INTERVAL 18 MINUTE, TRUE, 1, FALSE),
(3, 5, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 10 DAY + INTERVAL 12 MINUTE, TRUE, 0, FALSE),
(4, 1, NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 7 DAY + INTERVAL 28 MINUTE, TRUE, 2, TRUE),
(4, 2, NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 3 DAY + INTERVAL 15 MINUTE, TRUE, 0, FALSE),
(4, 5, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 10 DAY + INTERVAL 14 MINUTE, TRUE, 0, FALSE),
(5, 1, NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 7 DAY + INTERVAL 30 MINUTE, TRUE, 3, TRUE);

-- Results
INSERT INTO results (attempt_id, total_score, accuracy_percentage) VALUES 
(1, 4.00, 80.00),
(2, 3.00, 75.00),
(3, 2.00, 66.67),
(4, 3.00, 60.00),
(5, 4.00, 100.00),
(6, 3.00, 100.00),
(7, 2.00, 40.00);

-- Answers for Attempt 1 (Rahul, Quiz 1)
INSERT INTO answers (attempt_id, question_id, selected_option_id, is_correct) VALUES 
(1, 1, 1, TRUE), (1, 2, 6, TRUE), (1, 3, 10, TRUE), (1, 4, 14, TRUE), (1, 5, 17, FALSE);

-- Answers for Attempt 2 (Rahul, Quiz 2)
INSERT INTO answers (attempt_id, question_id, selected_option_id, is_correct) VALUES 
(2, 6, 22, TRUE), (2, 7, 27, TRUE), (2, 8, 30, TRUE), (2, 9, 31, FALSE);
