class Comment < ActiveRecord::Base
  # acts_as_voteable Killed due to Heroku angriness. Not sure if used.
  
  include ActsAsCommentable::Comment

  #belongs_to :match# might need this back in with environment types? there's more, :polymorphic => true

  default_scope :order => 'created_at ASC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  #TODO: is this okay?
  
  def user_name
    (self.user and self.user.username) or 'Anonymous'
  end

   def magic_ranking
      time_since_creation = (Time.now - self.created_at).to_i
      votes_score = self.votes_for + 1 #to avoid division by zero_partly
      
      base_rank = time_since_creation / votes_score
      
       if not self.user.nil?
        base_rank /= 2
        if Time.now - self.user.created_at > 7.days
          base_rank /= 2
        end
      end
      base_rank  
    end
end
