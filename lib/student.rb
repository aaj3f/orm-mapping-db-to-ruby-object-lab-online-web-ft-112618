require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    rows = DB[:conn].execute("SELECT * FROM students;")
    rows.map {|stud| Student.new_from_db(stud)}
  end

  def self.find_by_name(name)
    row = DB[:conn].execute(<<~SQL, name)[0]
    SELECT * FROM students WHERE students.name = ?
    SQL
    self.new_from_db(row)
  end

  def save
    DB[:conn].execute(<<~SQL, self.name, self.grade)
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
  end

  def self.create_table
    DB[:conn].execute(<<~SQL)
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    rows = DB[:conn].execute(<<~SQL)
      SELECT * FROM students WHERE students.grade = 9
    SQL
    rows.map {|stud| Student.new_from_db(stud)}
  end

  def self.students_below_12th_grade
    rows = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    rows.map {|stud| Student.new_from_db(stud)}
  end

  def self.first_X_students_in_grade_10(x)
    rows = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x)
    rows.map {|stud| Student.new_from_db(stud)}
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(x)
    rows = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x)
    rows.map {|stud| Student.new_from_db(stud)}
  end
end
