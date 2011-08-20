class Battle < ActiveRecord::Base
  belongs_to :winner, :class_name => "Animal" #, :foreign_key => "winner_id"
  belongs_to :loser,  :class_name => "Animal" #, :foreign_key => "loser_id"

  belongs_to :match
  
  validates_presence_of :winner
  validates_presence_of :loser
  validates_presence_of :match

  before_validation do
    self.match = Match.get_or_create_with(self.winner, self.loser) #TODO: what are the performance implications of this?
  end

	def battles
		Battle.find(:conditions => ["winner_id = ? OR loser_id = ?", id, id])
	end
	
	def stats
	  num_battles = self.match.battle_count
	  if num_battles > 1
	    wins = self.match.wins_for(self.winner).count
	    losses = num_battles - wins
	    return BattleStats::PriorVotes.new(self.winner, wins, losses)
	  else
	    return BattleStats::NoPriorVotes.new
	  end
	end
	
	def self.generate_new
    battle = Battle.new
    opponent_1, opponent_2 = pick_opponents
    match = Match.get_or_create_with(opponent_1, opponent_2)
    battle.match_id = match.id
    match.save
    battle
  end
	
	
	#---------
	
	#TODO: why can't I call these with self or just plain?
def self.pick_opponents
  n = rand(100)
  
  if n < 70
    Battle.make_random_close_match
  elsif n < 75
    Battle.make_new_close_match
  elsif n < 95
    Battle.make_random_match
  else
    Battle.make_new_random_match
  end
end

def self.make_random_match
  confirm_enough_animals(2)
  
  opponent_1 = Animal.random
  opponent_2 = opponent_1.random_opponent
  return opponent_1, opponent_2
end

def self.make_new_random_match
  confirm_enough_animals(2)
  
  opponent_1 = Animal.by_fewest_battles.first
  opponent_2 = opponent_1.random_opponent
  if rand(1) == 1
    tmp = opponent_1
    opponent_1 = opponent_2
    opponent_2 = tmp
  end
  return opponent_1, opponent_2
end
  
def self.make_new_close_match
  confirm_enough_animals(2)
  
  animals_ranked_by_fewest_battles = Animal.by_fewest_battles
  opponent_1 = animals_ranked_by_fewest_battles.first
  opponent_2 = opponent_1.closely_matched_opponent
  if rand(1) == 1
    tmp = opponent_1
    opponent_1 = opponent_2
    opponent_2 = tmp
  end
  return opponent_1, opponent_2
end

def self.make_random_close_match
  confirm_enough_animals(2)
  
  opponent_1 = Animal.random
  opponent_2 = opponent_1.closely_matched_opponent
  if rand(1) == 1
    tmp = opponent_1
    opponent_1 = opponent_2
    opponent_2 = tmp
  end
  return opponent_1, opponent_2
end

private
  def self.confirm_enough_animals(num_animals_needed)
    if Animal.count < num_animals_needed then raise Animal::NotEnoughAnimalsLoadedException end
  end
end
