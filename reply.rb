require_relative 'questions_database'

class Reply

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    Reply.new(reply)
  end

  def self.find_by_user(user_id)
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

  def self.find_by_question(question_id)
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
    @id = options[id]
    @user_id = options[user_id]
    @question_id = options[question_id]
    @parent_reply_id = options[parent_reply_id]
    @body = options[body]
  end
end
