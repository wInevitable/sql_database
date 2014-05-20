CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_followers(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id) 
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  body TEXT NOT NULL,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO 
  users (fname, lname)
VALUES
  ('Albert', 'Einstein'),
  ('M.C.', 'Esher');
  
INSERT INTO
  questions (title, body, user_id)
VALUES
  ('SQL?', 'Why so hard?', 1),
  ('Year?', 'What year is it?', 2);
  
INSERT INTO
  question_followers (user_id, question_id)
VALUES
  (1, 2),
  (2, 1);

INSERT INTO
  replies (question_id, user_id, body)
VALUES
  (1, 2, "Not using Active Record."),
  (2, 1, "It's all relative.");
  
INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 2),
  (2, 1);