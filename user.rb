require_relative 'questions_database'
require_relative 'model_base.rb'

class User < ModelBase

  def self.find_by_id(id)
    super(id)
  end

  def self.all
    super
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    User.new(user[0])
  end

  attr_accessor :fname, :lname
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_user_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    average_karma = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        COALESCE(SUM(question_likes.likes)/CAST(COUNT(DISTINCT questions.id) AS FLOAT), 0)
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.user_id = ?
    SQL
    average_karma.first.values.first
  end
end
