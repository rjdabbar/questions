require_relative 'questions_database'

class QuestionFollow

  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        questions.id = ?
    SQL

    users.map { |user| User.new(user) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      JOIN
        questions ON questions.id = question_follows.question_id
      WHERE
        users.id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id, COUNT(question_follows.user_id) AS followers
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      GROUP BY
        question_follows.question_id
      ORDER BY
        followers DESC
      LIMIT
        ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def initialize(options = {})
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
