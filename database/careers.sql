CREATE TABLE IF NOT EXISTS careers (
  id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  interest_area VARCHAR(100) NOT NULL,
  description VARCHAR(255) NOT NULL,
  fit_reason VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS career_weights (
  career_id INT NOT NULL,
  category CHAR(1) NOT NULL,
  weight INT NOT NULL,
  PRIMARY KEY (career_id, category),
  FOREIGN KEY (career_id) REFERENCES careers(id)
);

DELETE FROM career_weights;
DELETE FROM careers;

INSERT INTO careers (id, name, interest_area, description, fit_reason) VALUES
(1, 'Software Developer', 'Technical, logical', 'Designs, builds and tests software applications.', 'Technical and logical fit'),
(2, 'Cybersecurity Analyst', 'Technical, investigative', 'Protects systems and data from threats.', 'Realistic and investigative fit'),
(3, 'Data Analyst', 'Analytical, investigative', 'Finds patterns in data and reports the findings.', 'Investigative and conventional fit'),
(4, 'UI/UX Designer', 'Creative, user-focused', 'Designs how apps and websites look and feel to use.', 'Artistic and user-focused fit'),
(5, 'Graphic Designer', 'Creative, artistic', 'Creates visual content for brands, print and digital media.', 'Artistic and creative fit'),
(6, 'Teacher / Educator', 'Social, communication', 'Teaches and guides learners of different ages.', 'Social and communication fit'),
(7, 'Counsellor', 'Social, people-focused', 'Supports people with personal, study and career choices.', 'Social and people-focused fit'),
(8, 'Business Analyst', 'Analytical, business', 'Connects business needs with technical solutions.', 'Investigative and business fit'),
(9, 'Entrepreneur', 'Leadership, business', 'Starts and runs a business, taking on risk for growth.', 'Enterprising and creative fit'),
(10, 'Accountant', 'Numerical, organized', 'Records, checks and reports financial information.', 'Conventional and numerical fit');

INSERT INTO career_weights (career_id, category, weight) VALUES
(1, 'R', 2), (1, 'I', 2), (1, 'A', 0), (1, 'S', 0), (1, 'E', 0), (1, 'C', 1),
(2, 'R', 1), (2, 'I', 3), (2, 'A', 0), (2, 'S', 0), (2, 'E', 0), (2, 'C', 2),
(3, 'R', 0), (3, 'I', 3), (3, 'A', 0), (3, 'S', 0), (3, 'E', 1), (3, 'C', 3),
(4, 'R', 1), (4, 'I', 1), (4, 'A', 3), (4, 'S', 1), (4, 'E', 0), (4, 'C', 0),
(5, 'R', 1), (5, 'I', 0), (5, 'A', 3), (5, 'S', 0), (5, 'E', 1), (5, 'C', 1),
(6, 'R', 0), (6, 'I', 1), (6, 'A', 0), (6, 'S', 3), (6, 'E', 1), (6, 'C', 1),
(7, 'R', 0), (7, 'I', 1), (7, 'A', 1), (7, 'S', 3), (7, 'E', 0), (7, 'C', 1),
(8, 'R', 0), (8, 'I', 2), (8, 'A', 0), (8, 'S', 1), (8, 'E', 2), (8, 'C', 2),
(9, 'R', 1), (9, 'I', 0), (9, 'A', 1), (9, 'S', 1), (9, 'E', 3), (9, 'C', 0),
(10, 'R', 0), (10, 'I', 1), (10, 'A', 0), (10, 'S', 0), (10, 'E', 1), (10, 'C', 3);