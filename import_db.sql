DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  user_id INTEGER
);

CREATE TABLE question_follows (
  user_id INTEGER,
  question_id INTEGER
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER,
  body TEXT
);

CREATE TABLE question_likes (
  user_id INTEGER,
  question_id INTEGER,
  likes INTEGER
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Aiven', 'Song'), ('RJ', 'Dabbar');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Question 1', 'How do magnets work?', (SELECT id FROM users WHERE fname = 'Aiven')),
  ('Question 2', 'Why is the sky blue?', (SELECT id FROM users WHERE fname = 'RJ'));

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Aiven'),
    (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE fname = 'Aiven'))),
  ((SELECT id FROM users WHERE fname = 'RJ'),
    (SELECT id FROM questions WHERE user_id = (SELECT id FROM users WHERE fname = 'RJ')));

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Question 1'), NULL,
    (SELECT id FROM users WHERE fname = 'Aiven'), 'Magnets are miracles'),
  ((SELECT id FROM questions WHERE title = 'Question 2'), NULL,
    (SELECT id FROM users WHERE fname = 'RJ'), 'The sky is actually green, little known fact');


INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Question 1'), (SELECT id from replies WHERE body = 'Magnets are miracles'),
    (SELECT id FROM users WHERE fname = 'RJ'), 'Magnets are pretty cool yo'),
  ((SELECT id FROM questions WHERE title = 'Question 2'), (SELECT id from replies WHERE body = 'The sky is actually green, little known fact'),
    (SELECT id FROM users WHERE fname = 'Aiven'), 'ur dumb');

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Question 1'), (SELECT id from replies WHERE body = 'Magnets are pretty cool yo'),
    (SELECT id FROM users WHERE fname = 'Aiven'), 'I agree!'),
  ((SELECT id FROM questions WHERE title = 'Question 2'), (SELECT id from replies WHERE body = 'ur dumb'),
    (SELECT id FROM users WHERE fname = 'RJ'), 'no u');

INSERT INTO
  question_likes (user_id, question_id, likes)
VALUES
  ((SELECT id FROM users WHERE fname = "Aiven"), (SELECT id FROM questions WHERE title = 'Question 1'), 5),
  ((SELECT id FROM users WHERE fname = "RJ"), (SELECT id FROM questions WHERE title = 'Question 1'), 3),
  ((SELECT id FROM users WHERE fname = "Aiven"), (SELECT id FROM questions WHERE title = 'Question 2'), 1),
  ((SELECT id FROM users WHERE fname = "RJ"), (SELECT id FROM questions WHERE title = 'Question 2'), 4);