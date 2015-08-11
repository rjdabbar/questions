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
  # top_followed = QuestionFollow.most_followed_questions(3)
  # p top_followed

  #QuestionLike.num_likes_for_question_id(2)

  # p QuestionLike.liked_questions_for_user_id(4)

  # p User.find_by_id(1).average_karma

  # first_test_user =  User.find_by_name('Test', 'User')
  # p first_test_user
  # first_test_user.fname = "Bob"
  # first_test_user.save
  # p User.find_by_id(first_test_user.id)

  # test_q = Question.new
  # test_q.title = 'TEST QUESTION'
  # test_q.body = "THIS IS A BODY"
  # test_q.user_id = 2
  # test_q.save
  #
  # second_q = Question.find_by_title('TEST QUESTION')
  #
  # second_q.title = "I CHANGED IT"
  # second_q.save
  # p Question.find_by_title('I CHANGED IT')

  test_reply = Reply.new( { "user_id" => 1, "question_id" => 1, "body" => "meh" } )
  test_reply.save
  p User.find_by_id(1).authored_replies
end
