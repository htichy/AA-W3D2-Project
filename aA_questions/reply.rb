require_relative 'questions_database'

class Reply
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
  
  def author
    
  end 
  
  def question 
  end 
  
  def parent_reply
  end 
  
  def child_reply
    #only find the children (one level deep) don't find grandchildren elements
  end 
end 