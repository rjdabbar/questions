require_relative 'questions_database.rb'
class Question

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL
    Question.new(question[0])
  end

  def self.find_by_title(title)
    question = QuestionDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.title = ?
    SQL
    Question.new(question[0])
  end

  def self.find_by_user(user_id)
    questions = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.user_id = ?
    SQL
    questions.map {|question| Question.new(question)}
  end

  attr_accessor :title, :body
  attr_reader :id, :user_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    User.find_by_question(self.id)
  end

  def replies
    Reply.find_by_question(self.id)
  end
end
