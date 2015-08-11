require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
      super('questions.db')
      self.results_as_hash = true
      self.type_translation = true
    end
end

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
    Question.new(question)
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
    Question.new(question)
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
    @id = options[id]
    @title = options[title]
    @body = options[body]
    @user_id = options[user_id]
  end
end
