class User < TableMaster
  
  attr_accessor :fname, :lname, :id
  
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def table
    "users"
  end
  
  def self.find_by_name(fname,lname)
    results = QuestionDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE users.fname = ? AND users.lname = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
#  def save
#    if self.id
#      QuestionDatabase.instance.execute(<<-SQL, fname, lname, self.id)
#        UPDATE users
#        SET fname = ?, lname = ?
#        WHERE users.id = ?
#      SQL
#    else
#      QuestionDatabase.instance.execute(<<-SQL, fname, lname)
#        INSERT INTO users (fname, lname)
#        VALUES (?, ?)      
#      SQL
    
#      @id = QuestionDatabase.instance.last_insert_row_id
#    end
#  end
  
  def average_karma
    results = QuestionDatabase.instance.execute(<<-SQL, self.id)
    SELECT q_lk/CAST(q_ct AS FLOAT)
    FROM (SELECT questions.user_id u_id, COUNT(DISTINCT(question_id)) q_ct, COUNT(question_likes.question_id) q_lk
          FROM questions
          LEFT OUTER JOIN question_likes
          ON questions.id = question_likes.question_id
          WHERE questions.user_id = ?
          GROUP BY questions.user_id
        )
    SQL
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end
  
  def authored_questions
    Question.find_by_author_id(self.id)
  end
  
  def authored_replies
    Reply.find_by_user_id(self.id)
  end
  
  def self.find_by_id(id)
    results = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE users.id = ?
    SQL
    
    results.map { |result| User.new(result) }.first
  end
end