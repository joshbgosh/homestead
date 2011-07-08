class Match < ActiveRecord::Base
  has_many :battles
  belongs_to :opponent_1, :class_name => "Animal"
  belongs_to :opponent_2, :class_name => "Animal"
  
  acts_as_commentable
  
  def self.get_or_create_with(animal_1, animal_2) #TODO: could be cleaner
    match = find_with(animal_1, animal_2)
    if match
      return match
    else
      m = Match.create(:opponent_1_id => animal_1.id, :opponent_2_id => animal_2.id)
      m.save
      return m
    end
  end
  
  def self.find_with(animal_1, animal_2)
    matches = Match.where("(opponent_1_id = ? AND opponent_2_id = ?) OR (opponent_1_id = ? AND opponent_2_id = ?)",
     animal_1.id, animal_2.id, animal_2.id, animal_1.id) 
    if matches.count == 0
      return nil
    elsif matches.count == 1
      matches.first
    else
      matches.first #TODO: need to be throwing a warning or something here
    end
  end
end
