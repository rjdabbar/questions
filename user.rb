require_relative 'questions_database'

class User

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    User.new(user)
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
    SQL

    User.new(user)
  end

  attr_accessor :fname, :lname
  attr_reader :id

  def initalize(options = {})
    @id = options[id]
    @fname = options[fname]
    @lname = options[lname]
  end
end
