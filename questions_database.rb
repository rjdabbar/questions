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

  p User.find_by_id(1).average_karma
end
