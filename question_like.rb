require_relative 'questions_database.rb'

class QuestionLike
  def self.likers_for_question(question_id)
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

  attr_reader :user_id, :question_id, :likes

  def initialize( options = {} )
    @user_id = options['user_id']
    @question_id = options['question_id']
    @likes = options['likes']
  end
end
