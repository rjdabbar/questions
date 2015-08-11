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
  top_followed = QuestionFollow.most_followed_questions(3)
  p top_followed


end
