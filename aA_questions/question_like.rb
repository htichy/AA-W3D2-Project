require_relative 'questions_database'

class QuestionLike
  CON = QuestionsDatabase.instance
  
  def self.find_by_id(id)
    like = CON.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    
    QuestionLike.new(like.first)
  end 
  
  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end 
end 