require_relative 'questions_database'

class User 
  CON = QuestionsDatabase.instance
  
  def self.find_by_id(id)
    user = CON.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    raise "Not an ID in the database" if user.empty?
    User.new(user.first)
  end 
  
  def self.all
    results = CON.execute("SELECT * FROM users")
    results.map { |result| User.new(result) }
  end
  
  def self.find_by_name(fname, lname)
    results = CON.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
      AND
        lname = ?
    SQL
    results.map { |name| User.new(name) }
  end
  
  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end
  
  def authored_questions
    Question.find_by_user_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions 
    QuestionFollow.followed_questions_for_user_id(@id)
  end 
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end 
  
  def average_karma
    result = CON.execute(<<-SQL, @id)
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT)/ COUNT(DISTINCT (question_id)) AS avg_likes_per_question
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_id
      WHERE 
        questions.user_id = ?
    SQL
    result.first["avg_likes_per_question"]
  end
  
  def inspect 
    "ID=#{@id} Name=#{@fname} #{@lname}"
  end 
end 