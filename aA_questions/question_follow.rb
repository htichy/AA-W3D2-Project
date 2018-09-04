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
  
  def self.all
    results = CON.execute("SELECT * FROM question_follows")
    results.map { |result| QuestionFollow.new(result) }
  end
  
  def self.followers_for_question_id(question_id)
    results = CON.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows on user_id = users.id
      WHERE
        question_id = ?
    SQL
    results.map { |result| User.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = CON.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows on question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end
  
  def self.most_followed_questions(n)
    results = CON.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM 
        questions
      JOIN 
        question_follows ON question_follows.question_id = questions.id
      GROUP BY 
        questions.id
      ORDER BY COUNT(questions.id)
      LIMIT ?  
    SQL
    results.map {|result| Question.new(result)}
  end 
  
  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
  
  
end 