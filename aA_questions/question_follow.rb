require_relative 'questions_database'

class QuestionFollow
  CON = QuestionsDatabase.instance
  
  def self.find_by_id(id)
    question_follow = CON.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    
    QuestionFollow.new(question_follow.first)
  end 
  
  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end 