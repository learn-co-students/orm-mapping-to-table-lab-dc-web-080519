class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name, @grade, @id = name, grade, id
  end

  def self.create_table
    # SQL command to create table saved in string
    sql =
    <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    # run SQL command on database connection
    DB[:conn].execute(sql)
  end

  def self.drop_table
    # SQL to drop table saved in string
    sql =
    <<-SQL
      DROP TABLE students
    SQL
    # run SQL on DB connection
    DB[:conn].execute(sql)
  end

  def save
    # SQL to create new entry - ?s are placeholder values
    sql =
    <<-SQL
      INSERT INTO students (name, grade)
      VALUES (? , ?);
    SQL
    # run SQL and insert appropriate instance values into SQL command
    DB[:conn].execute(sql, self.name, self.grade)
    # assign ID of newly created row to @id for this instance
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    # create new instance by passing in argument hash
    student = Student.new(name, grade)
    # run Student#save on new method
    student.save
    # return saved instance
    student
  end
end
