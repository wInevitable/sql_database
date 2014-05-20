class Reply < TableMaster
  
  attr_accessor :user_id, :question_id, :reply_id, :body, :id
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @body = options['body']
  end
  
  def table
    "replies"
  end

#  def save
#    if self.id
#     QuestionDatabase.instance.execute(<<-SQL, user_id, question_id, reply_id, body, self.id)
#        UPDATE replies
#        SET user_id = ?, question_id = ?, reply_id = ?, body = ?
#        WHERE replies.id = ?
#      SQL
#    else
#      QuestionDatabase.instance.execute(<<-SQL, user_id, question_id, reply_id, body)
#        INSERT INTO replies (user_id, question_id, reply_id, body)
#        VALUES (?, ?, ?, ?)      
#      SQL
    
#      @id = QuestionDatabase.instance.last_insert_row_id
#    end
#  end
  
  def reply
    results = QuestionDatabase.instance.execute(<<-SQL, self.reply_id)
      SELECT * FROM replies WHERE id = ?
    SQL
    
    results.map { |result| Reply.new(result) }
  end
  
  def child_replies
    results = QuestionDatabase.instance.execute(<<-SQL, self.id)
      SELECT * FROM replies WHERE reply_id = ?
    SQL
    
    results.map { |result| Reply.new(result) }
  end
  
  def author
    results = QuestionDatabase.instance.execute(<<-SQL, self.user_id)
      SELECT * FROM users WHERE id = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def question
    results = QuestionDatabase.instance.execute(<<-SQL, self.question_id)
      SELECT * FROM questions WHERE id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def self.find_by_user_id(user_id)
    results = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT * FROM replies WHERE user_id = ?
    SQL
    
    results.map { |result| Reply.new(result) }
  end  
  
  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE replies.id = ?
    SQL
    
    results.map { |result| Reply.new(result) }.first
  end
  
  def self.find_by_question_id(question_id)
    results = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT * FROM replies WHERE question_id = ?
    SQL
    
    results.map { |result| Reply.new(result) }
  end
end