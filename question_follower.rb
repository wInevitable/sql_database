class QuestionFollower
  
  attr_accessor :user_id, :question_id, :id
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.most_followed_questions(n)
    results = QuestionDatabase.instance.execute(<<-SQL)
    SELECT questions.id, questions.title, questions.body, questions.user_id, y
    FROM (SELECT question_id x, COUNT(user_id) y
      FROM question_followers
      GROUP BY question_id
      ORDER BY 2 DESC) freq_table
    JOIN questions
    ON freq_table.x = questions.id
    SQL
    
    results.map { |result| Question.new(result) }[0...n]
  end
  
  def self.followers_for_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id,fname,lname FROM question_followers
      INNER JOIN users
      ON user_id = users.id
      WHERE question_id = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.id, title, body, questions.user_id FROM question_followers
      INNER JOIN questions
      ON questions.id = question_id
      WHERE question_followers.user_id = ?
    SQL
    results.map { |result| Question.new(result) }
  end
  
  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM question_followers WHERE question_followers.id = ?
    SQL
    
    results.map { |result| QuestionFollower.new(result) }.first
  end
end