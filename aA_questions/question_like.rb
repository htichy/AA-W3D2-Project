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
  
  def self.likers_for_question_id(question_id)
    results = CON.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id IN (
          SELECT
            user_id
          FROM
            question_likes
          WHERE
            question_id = ?
        )
    SQL
    results.map { |result| User.new(result) }
  end
  
  def self.num_likes_for_question_id(question_id)
    results = CON.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS num_likes
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    results.first["num_likes"]
  end
  
  def self.liked_questions_for_user_id(user_id)
    results = CON.execute(<<-SQL, user_id)
      SELECT 
        *
      FROM 
        questions
      WHERE 
        questions.id IN (
          SELECT 
            question_id
          FROM 
          -- question_likes = | id | user_id | question_id |
            question_likes 
          WHERE 
            user_id = ?
        )
    SQL
    results.map { |result| Question.new(result) }
  end
  
  def self.most_liked_questions(n)
    results = CON.execute(<<-SQL, n)
      SELECT 
        questions.*
      FROM 
        questions
      JOIN 
        question_likes ON question_likes.question_id = questions.id
      GROUP BY 
        questions.id
      ORDER BY 
        COUNT(*)
      LIMIT ?
    SQL
    results.map { |result| Question.new(result)}
  end 
  
  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end 
end 