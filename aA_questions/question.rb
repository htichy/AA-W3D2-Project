require_relative 'questions_database'
require_relative 'user'
class Question
  attr_accessor :title, :body, :user_id
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

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end 
    
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
        
  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end 
  
  def create
    raise "#{self} is already in the database" if @id
    CON.execute(<<-SQL, @title, @body, @user_id)
      INSERT INTO 
        questions(title, body, user_id)
      VALUES 
        (?, ?, ?)
    SQL
    @id = CON.last_insert_row_id
  end 
  
  def update
    raise "#{self} is not in the database" unless @id
    CON.execute(<<-SQL,  @title, @body, @user_id, @id)
      UPDATE 
        questions(title, body, user_id)
      SET 
        title = ?, body = ?, user_id = ?
      WHERE 
        id = ?
    SQL
    self
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
  
  def likers 
    QuestionLike.likers_for_question_id(@id)
  end 
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end 

end 