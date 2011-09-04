class User < ActiveRecord::Base
  acts_as_voter
  
  USERNAME_LENGTH = 1..24
  
  validates_presence_of   :username, :if => :username_changed?
  validates_uniqueness_of :username, :case_sensitive => false, :if => :username_changed?
  validates_length_of :username, :within => USERNAME_LENGTH
  
  EMAIL_REGEXP = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  
  validates_uniqueness_of :email, :case_sensitive => false, :if => :email_changed?, :unless => Proc.new { |a| a.email.blank? }
  validates_format_of     :email, :with  => EMAIL_REGEXP,  :if => :email_changed?, :unless => Proc.new { |a| a.email.blank? }

  PASSWORD_LENGTH = 6..128
  
  validates_presence_of     :password
  validates_confirmation_of :password
  validates_length_of       :password, :within => PASSWORD_LENGTH
            
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  
  #TODO: check if double votes are still possible somehow. Should be prevented in database and comment model ideally.
  #TODO: make sure that voting for comments that don't exist doesn't cause crappiness.
  
  def unique_vote_for(comment)
    if voted_against?(comment)
        # update the old vote
        vote = votes.find_by_voteable_id(comment.id)
        vote.vote = true
        vote.save
    elsif voted_for?(comment)
      return
    else
       vote_for(comment)
    end    
  end
  
  def unique_vote_against(comment)
    if voted_for?(comment)
        # update the old vote
        vote = votes.find_by_voteable_id(comment.id)
        vote.vote = false
        vote.save
    elsif voted_against?(comment)
      return
    else 
       vote_against(comment)
    end
  end
    
  def unique_undo_vote_on(comment)
     if voted_on?(comment)
         vote = votes.find_by_voteable_id(comment.id)
         vote.destroy
     else
       return #can't undo that which was never done!
     end
  end
end
