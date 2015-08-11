require_relative 'questions_database.rb'

class QuestionLike
  def self.likers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL
    users.map { |user| User.new(user) }
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        SUM(question_likes.likes)
      FROM
        question_likes
      GROUP BY
        question_likes.question_id
      HAVING
        question_likes.question_id = ?
    SQL

    num_likes.first.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.id, questions.title, questions.body, questions.user_id, SUM(question_likes.likes) AS total_likes
    FROM
      question_likes
    JOIN
      questions ON question_likes.question_id = questions.id
    GROUP BY
      question_likes.question_id
    ORDER BY
      total_likes DESC
    LIMIT
      ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  attr_reader :user_id, :question_id, :likes

  def initialize( options = {} )
    @user_id = options['user_id']
    @question_id = options['question_id']
    @likes = options['likes']
  end
end
