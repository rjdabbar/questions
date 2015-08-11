require_relative 'questions_database.rb'
class ModelBase
  DB_HASH = {'Reply' => 'replies', 'Question' => 'questions', 'User' => 'users'}

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        '#{DB_HASH[self.to_s]}'
      WHERE
        id = ?
    SQL
    results.map { |result| self.new(result) }.first
  end

  def self.all
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        '#{DB_HASH[self.to_s]}'
      SQL
      results.map { |result| self.new(result) }
  end

  def self.where(options)
    columns = options.keys
    values = options.values

    where_col = columns.map { |col| col.to_s + " = ?" }.join(" AND ")
    results = QuestionsDatabase.instance.execute(<<-SQL, *values)
    SELECT
      *
    FROM
      #{DB_HASH[self.to_s]}
    WHERE
      #{where_col}
    SQL
    results.map { |result| self.new(result) }
  end

  def self.method_missing(method, *args)
    self.where(method.to_s.gsub('find_by_', '').split("_and_").zip(args).to_h)
  end

  def save
    self.id.nil? ? insert : update
  end

  def insert
    ivars = self.instance_variables
    ivars.shift
    methods = ivars.map { |var| var.to_s.gsub('@','').to_sym }
    called_methods = methods.map { |method| self.send(method) }

    ivars_string = ivars.map(&:to_s).map{ |var| var[1..-1] }.join(", ")
    q_marks = ivars.map { |el| '?' }.join(', ')

    QuestionsDatabase.instance.execute(<<-SQL, *called_methods)
      INSERT INTO
        #{DB_HASH[self.class.to_s]} (#{ivars_string})
      VALUES
        (#{q_marks})
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    ivars = self.instance_variables
    ivars.rotate!
    methods = ivars.map { |var| var.to_s.gsub('@','').to_sym }
    called_methods = methods.map { |method| self.send(method) }

    set_string = ivars[0...-1].map { |var| var.to_s[1..-1] + " = ?" }.join(", ")

    QuestionsDatabase.instance.execute(<<-SQL, *called_methods)
      UPDATE
        #{DB_HASH[self.class.to_s]}
      SET
        #{set_string}
      WHERE
        id = ?
    SQL
  end
end
