module BattlesHelper
  
  SHOW_COMMENTS_BY_DEFAULT = true
  
  def comments_visibility_preference
    case cookies[:show_comments]
    when nil
      puts "SHOW COMMENTS WUZ DEFAULT"
      return SHOW_COMMENTS_BY_DEFAULT
    when "true"
       puts cookies[:show_comments]
       puts "SHOW COMMENTS WUZ TRUUUUU"
      return true
    when "false"
       puts "SHOW COMMENTS WUZ FALSE"
      return false
    else
       puts "SHOW COMMENTS WUZ SOMETHIN ELSE"
      return SHOW_COMMENTS_BY_DEFAULT
    end
  end
end
