require_relative 'questions_database'
require_relative 'model_base.rb'

class Reply < ModelBase

  def self.find_by_id(id)
    super(id)
  end

  def self.all
    super
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.user_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_parent_reply(parent_reply_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply_id = ?
    SQL

    replies.map { |reply| Reply.new(reply) }
  end

  attr_accessor :body
  attr_reader :id, :user_id, :question_id, :parent_reply_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_reply_id)
  end

  def child_replies
    children = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply_id = ?
    SQL
    children.map { |child_reply| Reply.new(child_reply) }
  end

end
