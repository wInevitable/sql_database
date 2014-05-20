class QuestionLike
  
  attr_accessor :user_id, :question_id, :id
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  def self.likers_for_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, users.fname, users.lname
      FROM question_likes
      JOIN users ON user_id = users.id
      WHERE question_id = ?
    SQL
    
    results.map {|result| Reply.new(result) }
  end
  
  def self.most_liked_questions(n)
    results = QuestionDatabase.instance.execute(<<-SQL)
      SELECT questions.id, questions.title, questions.body, questions.user_id
      FROM questions
      JOIN
        (SELECT question_id, COUNT(question_id)
        FROM question_likes
        GROUP BY question_id
        ORDER BY 2 DESC)
      ON question_id = questions.id
    SQL
    
    results.map { |result| Question.new(result) }[0...n]
  end
  
  def self.num_likes_for_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT question_id, COUNT(question_id) count
      FROM question_likes
      WHERE question_id = ?
      GROUP BY question_id
    SQL
    
    results.last["count"]
  end
  
  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM question_likes WHERE question_likes.id = ?
    SQL
    
    results.map { |result| QuestionLike.new(result) }.first
  end
end