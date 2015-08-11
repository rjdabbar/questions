require 'singleton'
require 'sqlite3'

require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'user.rb'
require_relative 'question_follow.rb'
require_relative 'question_like.rb'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
      super('questions.db')
      self.results_as_hash = true
      self.type_translation = true
    end
end


if $PROGRAM_NAME == __FILE__
  # q = Question.new( {'title' => 'Test Question', 'body' => 'This is a test.', 'user_id' => 1 } )
  # q.save

  # new_q = Question.find_by_id(10)
  # p new_q
  # new_q.title = "TEST TITLE CHANGED"
  # new_q.save
  # p Question.all

  # p Question.where({id: 1})

  p Reply.find_by_user_id_and_question_id(1, 1)
end
