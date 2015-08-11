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
