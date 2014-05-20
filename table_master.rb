class TableMaster
  def save
    i_v = self.instance_variables.delete(:@id)
    
    columns = i_v.map { |col| col.to_s[1..-1] }.join(', ')
    
    values = i_v.map { |iv| "'#{self.instance_variables_get(iv)}'" }.join(', ')
    
    save_string = i_v
      .map { |iv| "#{iv.to_s[1..-1]} = '#{self.instance_variable_get(iv)}'" }
      .join(', ')
    
    if id
      QuestionDatabase.instance.execute(<<-SQL, self.id)
        UPDATE #{table}
        SET #{save_string}
        WHERE id = ?        
      SQL
    else
      QuestionDatabase.instance.execute(<<-SQL)
        INSERT INTO #{table} (#{columns})
        VALUES (#{values})
                   
      SQL
      
      @id = QuestionDatabase.instance.last_insert_row_id
    end    
  end
end