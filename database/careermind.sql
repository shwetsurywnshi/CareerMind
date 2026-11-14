DROP TABLE IF EXISTS student_skills;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS options;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  course VARCHAR(50),
  year VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE skills (
  id INT AUTO_INCREMENT PRIMARY KEY,
  skill_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quiz_type VARCHAR(20) NOT NULL,
  question_text VARCHAR(255) NOT NULL,
  q_order INT NOT NULL,
  skill_id INT NULL,
  FOREIGN KEY (skill_id) REFERENCES skills(id)
);

CREATE TABLE options (
  id INT AUTO_INCREMENT PRIMARY KEY,
  question_id INT NOT NULL,
  option_text VARCHAR(255) NOT NULL,
  category CHAR(1) NULL,
  rating INT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE answers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  question_id INT NOT NULL,
  option_id INT NOT NULL,
  UNIQUE KEY uq_answer (student_id, question_id),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (option_id) REFERENCES options(id)
);

CREATE TABLE student_skills (
  student_id INT NOT NULL,
  skill_id INT NOT NULL,
  rating TINYINT NOT NULL,
  PRIMARY KEY (student_id, skill_id),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (skill_id) REFERENCES skills(id)
);

INSERT INTO skills (skill_name) VALUES
('Programming'), ('Mathematics'), ('Communication'), ('Data Analysis'),
('Problem Solving'), ('Design'), ('Networking'), ('Accounting'),
('Teaching'), ('Leadership');

INSERT INTO questions (quiz_type, question_text, q_order, skill_id) VALUES
('interest', 'Which activity do you enjoy most?', 1, NULL),
('interest', 'Which subject interests you most?', 2, NULL),
('interest', 'Which task would you prefer?', 3, NULL),
('interest', 'What would you most like to do?', 4, NULL),
('interest', 'What kind of work environment suits you best?', 5, NULL),
('interest', 'Which kind of problem would you rather solve?', 6, NULL),
('interest', 'Which role would you enjoy most in a group project?', 7, NULL),
('interest', 'What do you enjoy reading about?', 8, NULL),
('interest', 'Which kind of work would you find most satisfying?', 9, NULL),
('interest', 'Which kind of tool would you most like to use?', 10, NULL),
('skill', 'Programming: Which statement describes you best?', 11, 1),
('skill', 'Mathematics: How comfortable are you with solving math problems?', 12, 2),
('skill', 'Communication: How do you usually handle speaking or writing to a group?', 13, 3),
('skill', 'Data Analysis: Which describes your experience with data?', 14, 4),
('skill', 'Problem Solving: When you face an unfamiliar problem, what do you usually do?', 15, 5),
('skill', 'Design: How would you rate your design skills?', 16, 6),
('skill', 'Networking: How well do you set up and troubleshoot computer networks?', 17, 7),
('skill', 'Accounting: How comfortable are you with keeping accounts and financial records?', 18, 8),
('skill', 'Teaching: How well can you explain a topic to someone else?', 19, 9),
('skill', 'Leadership: How do you usually take charge in a group?', 20, 10);

INSERT INTO options (question_id, option_text, category, rating) VALUES
(1, 'Solving logical problems', 'I', NULL),
(1, 'Designing and creating', 'A', NULL),
(1, 'Helping or teaching people', 'S', NULL),
(1, 'Leading a team or business', 'E', NULL),
(1, 'Organizing records and files', 'C', NULL),
(2, 'Engineering and how machines work', 'R', NULL),
(2, 'Art and design', 'A', NULL),
(2, 'Psychology and social studies', 'S', NULL),
(2, 'Commerce and management', 'E', NULL),
(2, 'Accounting and financial records', 'C', NULL),
(3, 'Analyzing data', 'I', NULL),
(3, 'Solving technical problems', 'R', NULL),
(3, 'Explaining a topic to others', 'S', NULL),
(3, 'Planning and managing a project', 'E', NULL),
(3, 'Keeping accurate financial records', 'C', NULL),
(4, 'Research and investigate', 'I', NULL),
(4, 'Build or repair things', 'R', NULL),
(4, 'Create visual content', 'A', NULL),
(4, 'Manage a business', 'E', NULL),
(4, 'Maintain organized records', 'C', NULL),
(5, 'A lab or research setting', 'I', NULL),
(5, 'Outdoors or with tools and machines', 'R', NULL),
(5, 'A creative studio', 'A', NULL),
(5, 'A school or community centre', 'S', NULL),
(5, 'An office with clear routines and records', 'C', NULL),
(6, 'Finding the cause of a pattern in data', 'I', NULL),
(6, 'Fixing a broken machine or device', 'R', NULL),
(6, 'Designing something new that looks good', 'A', NULL),
(6, 'Helping someone through a personal difficulty', 'S', NULL),
(6, 'Growing a business and finding new customers', 'E', NULL),
(7, 'Researching the facts', 'I', NULL),
(7, 'Designing the presentation', 'A', NULL),
(7, 'Motivating everyone and keeping the team together', 'S', NULL),
(7, 'Leading the group and making decisions', 'E', NULL),
(7, 'Keeping the schedule and documents organized', 'C', NULL),
(8, 'Art, film, and design', 'A', NULL),
(8, 'Psychology and human behaviour', 'S', NULL),
(8, 'Business news and start-ups', 'E', NULL),
(8, 'Accounting and financial news', 'C', NULL),
(8, 'Engineering and how machines work', 'R', NULL),
(9, 'Solving a difficult puzzle or case', 'I', NULL),
(9, 'Building something that works well', 'R', NULL),
(9, 'Seeing someone you helped succeed', 'S', NULL),
(9, 'Starting a business that grows', 'E', NULL),
(9, 'Finishing an accurate report with no errors', 'C', NULL),
(10, 'A data analysis tool', 'I', NULL),
(10, 'Hand tools or machinery', 'R', NULL),
(10, 'Drawing or design software', 'A', NULL),
(10, 'A business planning tool', 'E', NULL),
(10, 'A spreadsheet for accounts', 'C', NULL),
(11, 'I have never written code', NULL, 0),
(11, 'I can follow a tutorial to write simple code', NULL, 1),
(11, 'I can build small programs on my own', NULL, 2),
(11, 'I can design and debug larger programs and help others', NULL, 3),
(12, 'I avoid math problems', NULL, 0),
(12, 'I can solve basic problems with help', NULL, 1),
(12, 'I can solve most problems on my own', NULL, 2),
(12, 'I can solve complex problems and explain them to others', NULL, 3),
(13, 'I find it very difficult', NULL, 0),
(13, 'I can do it when I prepare carefully', NULL, 1),
(13, 'I can present clearly most of the time', NULL, 2),
(13, 'I communicate confidently and adapt to any audience', NULL, 3),
(14, 'I have never worked with data', NULL, 0),
(14, 'I can read simple tables and charts', NULL, 1),
(14, 'I can clean and summarize data on my own', NULL, 2),
(14, 'I can find patterns and draw conclusions for others', NULL, 3),
(15, 'I usually give up or ask someone else immediately', NULL, 0),
(15, 'I can break down simple problems with guidance', NULL, 1),
(15, 'I can work through most problems step by step on my own', NULL, 2),
(15, 'I can solve complex problems and guide others through them', NULL, 3),
(16, 'I have never designed anything', NULL, 0),
(16, 'I can make simple layouts with a template', NULL, 1),
(16, 'I can create clean designs for projects on my own', NULL, 2),
(16, 'I can create professional designs and give design feedback', NULL, 3),
(17, 'I have no experience with networks', NULL, 0),
(17, 'I can connect to a network and fix basic issues', NULL, 1),
(17, 'I can set up a small network on my own', NULL, 2),
(17, 'I can design and secure larger networks', NULL, 3),
(18, 'I have no experience with accounting', NULL, 0),
(18, 'I can record simple income and expenses with help', NULL, 1),
(18, 'I can prepare basic accounts on my own', NULL, 2),
(18, 'I can prepare and check full financial statements', NULL, 3),
(19, 'I find it very hard to explain things', NULL, 0),
(19, 'I can explain basic ideas if I prepare first', NULL, 1),
(19, 'I can explain most topics clearly on my own', NULL, 2),
(19, 'I can teach a full topic and adjust to each learner', NULL, 3),
(20, 'I prefer not to lead', NULL, 0),
(20, 'I can lead a small task when asked', NULL, 1),
(20, 'I can organize a group and keep it on track', NULL, 2),
(20, 'I can lead a team, make decisions, and develop others', NULL, 3);