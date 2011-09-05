module BattlesHelper
  
  SHOW_COMMENTS_BY_DEFAULT = true
  
  def comments_visibility_preference
    case cookies[:show_comments]
    when nil
      return SHOW_COMMENTS_BY_DEFAULT
    when "true"
      return true
    when "false"
      return false
    else
      return SHOW_COMMENTS_BY_DEFAULT
    end
  end
  
  #helps me use devise partials from battle land.
  
    def resource_name
      :user
    end

    def resource
      @resource ||= User.new
    end

    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
    end
end
