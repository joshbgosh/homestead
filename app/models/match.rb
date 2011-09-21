class Match < ActiveRecord::Base
  has_many :ballots
  belongs_to :opponent_1, :class_name => "Animal"
  belongs_to :opponent_2, :class_name => "Animal"
  
  acts_as_commentable
  
  def wins_for(animal)
    raise ArgumentError, "you can't find the number of wins for a given animal in a match unless that animal is one of the animals in a match"  unless animal == self.opponent_1 or animal == self.opponent_2
    
    self.ballots.where("winner_id = ?", animal.id)
  end
  
  def losses_for(animal)
    raise ArgumentError, "you can't find the number of wins for a given animal in a match unless that animal is one of the animals in a match" unless animal == self.opponent_1 or animal == self.opponent_2
        
    self.ballots.where("loser_id = ?", animal.id)
  end
  
  def ballot_count
    self.ballots.count
  end
  
  def get_ranked_comments
    comments = self.comments.all
    comments.sort_by!{|comment| comment.magic_ranking} #this may not work with pagination, see http://stackoverflow.com/questions/657654/how-do-you-normally-sort-items-in-rails
  end
  
  def self.get_or_create_with(animal_1, animal_2) #TODO: could be cleaner
    match = find_with(animal_1, animal_2)
    if match
      return match
    else
      m = Match.create(:opponent_1_id => animal_1.id, :opponent_2_id => animal_2.id)
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
