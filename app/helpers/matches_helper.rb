module MatchesHelper
  def vote_status(comment)
    if user_signed_in? && current_user.voted_for?(comment)
      return "voted_for"
    elsif user_signed_in? && current_user.voted_against?(comment)
      return "voted_against"
    else
      return ""
    end
  end
end
