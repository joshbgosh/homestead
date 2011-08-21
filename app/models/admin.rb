class Admin < ActiveRecord::Base
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
  devise :database_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
end
