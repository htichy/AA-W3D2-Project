require_relative 'questions_database'

class User 
  CON = QuestionsDatabase.instance
  
  def self.find_by_id(id)
    user = CON.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    raise "Not an ID in the database" if user.empty?
    User.new(user.first)
  end 
  
  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end 
  
  def inspect 
    "ID=#{@id} Name=#{@fname} #{@lname}"
  end 
end 