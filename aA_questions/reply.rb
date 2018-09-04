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
  
  def initialize(options)
    @id = options["id"]
    @parent_reply_id = options["parent_reply_id"]
    @body = options["body"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end 
end 