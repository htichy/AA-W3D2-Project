require_relative 'questions_database'

class Reply
  attr_accessor :parent_reply_id, :body, :user_id, :question_id
  CON = QuestionsDatabase.instance
  
  def self.find_by_id(id)
    reply = CON.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    
    Reply.new(reply.first)
  end 
  
  def self.find_by_user_id(user_id)
    result = CON.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    
    result.map { |el| Reply.new(el) }
  end
  
  def self.find_by_question_id(question_id)
    result = CON.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    result.map { |el| Reply.new(el) }
  end
  
  def initialize(options)
    @id = options["id"]
    @parent_reply_id = options["parent_reply_id"]
    @body = options["body"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end 
  
  def create
    raise "#{self} is already in the database" if @id
    CON.execute(<<-SQL, @parent_reply_id, @body, @user_id, @question_id)
      INSERT INTO 
        replies(parent_reply_id, body, user_id, question_id)
      VALUES 
        (?, ?, ?, ?)
    SQL
    @id = CON.last_insert_row_id
  end 
  
  def update
    raise "#{self} is not in the database" unless @id
    CON.execute(<<-SQL, @parent_reply_id, @body, @user_id, @question_id, @id)
      UPDATE 
        replies(parent_reply_id, body, user_id, question_id)
      SET 
        parent_reply_id = ?, body = ?, user_id = ?, question_id = ?
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
  
  def question 
    results = CON.execute(<<-SQL, @question_id)
      SELECT 
        *
      FROM 
        questions
      WHERE 
        id = ?
    SQL
    Question.new(results.first)
  end 
  
  def parent_reply
    results = CON.execute(<<-SQL, @parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Reply.new(results.first)
  end 
  
  def child_replies
    results = CON.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end 
end 