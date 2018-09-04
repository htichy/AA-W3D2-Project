require_relative 'questions_database'
require_relative 'user'
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
   
  def self.find_by_user_id(user_id)
    questions = CON.execute(<<-SQL, user_id)
      SELECT 
        * 
      FROM 
        questions
      WHERE 
        user_id = ?
    SQL
    questions.map {|question| Question.new(question)}
  end 
  
  def self.all
    results = CON.execute("SELECT * FROM questions")
    results.map { |result| Question.new(result) }
  end
    
  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end 
  
  def author 
    results = CON.execute(<<-SQL, @user_id)
      SELECT 
        *
      FROM 
        users
      WHERE 
        id = ?
    SQL
    User.new(results.first)
  end 
    
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollow.followers_for_question_id(@id)
  end  
  
  
end 