require 'singleton'
require 'sqlite3'

require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'user.rb'
require_relative 'question_follow.rb'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
      super('questions.db')
      self.results_as_hash = true
      self.type_translation = true
    end
end


if $PROGRAM_NAME == __FILE__
  # q = Question.find_by_id(1)
  # # p q
  #
  # reply1 = Reply.find_by_id(1)
  # reply2 = Reply.find_by_id(2)
  #
  # # p reply1
  # # p reply2
  #
  # user1 = User.find_by_name('RJ', 'Dabbar')
  # # p user1
  #
  # p reply1.child_replies

  question_follows = QuestionFollow.followers_for_question(1)
  p question_follows

  questions_follower = QuestionFollow.followed_questions_for_user(2)
  p questions_follower
end
