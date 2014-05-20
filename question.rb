require_relative 'table_master'

class Question < TableMaster
  
  attr_accessor :id, :title, :body, :user_id 
  
  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def author
    results = QuestionDatabase.instance.execute(<<-SQL, self.user_id)
      SELECT * FROM users WHERE id = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def table
    "questions"
  end
  
#  def save
#    if self.id
#      QuestionDatabase.instance.execute(<<-SQL, title, body, user_id, self.id)
#      UPDATE questions
#      SET title = ?, body = ?, user_id = ?
#      WHERE questions.id = ?
#      SQL
#    else
#      QuestionDatabase.instance.execute(<<-SQL, title, body, user_id)
#        INSERT INTO questions (title, body, user_id)
#        VALUES (?, ?, ?)      
#      SQL
    
#      @id = QuestionDatabase.instance.last_insert_row_id
#    end
#  end
  
  
  def replies
    Reply.find_by_question_id(self.id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(self.id)
  end
  
  def likers
    QuestionLike.likers_for_question_id(self.id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end
  
  def self.liked_questions_for_user_id(user_id)
    results = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.id, questions.title, questions.body, questions.user_id
      FROM question_likes
      JOIN questions
      ON questions.id = question_id
      WHERE question_likes.user_id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def self.most_followed(n)
    QuestionFollower.followers_for_question_id(n)
  end
  
  def self.find_by_author_id(author_id)
    results = QuestionDatabase.instance.execute(<<-SQL, author_id)
      SELECT * FROM questions WHERE questions.user_id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE questions.id = ?
    SQL
    
    results.map { |result| Question.new(result) }.first
  end
end