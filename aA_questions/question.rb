require_relative 'questions_database'

class Question
  CON = QuestionsDatabase.instance
  
  def self.find_by_id(id)
    question = CON.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    
    Question.new(question.first)
  end 
  
  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end 
end 