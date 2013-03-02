class Ballot < ActiveRecord::Base
  belongs_to :winner, :class_name => "Animal" #, :foreign_key => "winner_id"
  belongs_to :loser,  :class_name => "Animal" #, :foreign_key => "loser_id"

  belongs_to :match
  
  validates_presence_of :winner
  validates_presence_of :loser
  validates_presence_of :match

  before_validation do
    self.match = Match.get_or_create_with(self.winner, self.loser) #TODO: what are the performance implications of this?
  end
  
  after_save :expire_animal_ballot_caches
  after_destroy :expire_animal_ballot_caches
  
  def expire_animal_ballot_caches
    winner.expire_ballot_caches
    loser.expire_ballot_caches
  end

	def ballots
		Ballot.find(:conditions => ["winner_id = ? OR loser_id = ?", id, id])
	end
	
	def stats
	  num_ballots = self.match.ballot_count
	  if num_ballots > 1
	    wins = self.match.wins_for(self.winner).count
	    losses = num_ballots - wins
	    return BallotStats::PriorVotes.new(self.winner, wins, losses)
	  else
	    return BallotStats::NoPriorVotes.new
	  end
	end
	
	def self.generate_new
    ballot = Ballot.new
    opponent_1, opponent_2 = pick_opponents
    match = Match.get_or_create_with(opponent_1, opponent_2)
    ballot.match_id = match.id
    match.save
    ballot
  end
	
	
	#---------
	
	#TODO: why can't I call these with self or just plain?
def self.pick_opponents
  n = rand(100)
  
  if n < 93
    Ballot.make_random_close_match
  elsif false #TODO: not sure this should be done at all any more. Leaving in for now though
    Ballot.make_new_close_match
  elsif n < 96
    Ballot.make_random_match
  else
    Ballot.make_new_random_match
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
  
  opponent_1 = Animal.by_fewest_ballots.first
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
  
  animals_ranked_by_fewest_ballots = Animal.by_fewest_ballots
  opponent_1 = animals_ranked_by_fewest_ballots.first
  opponent_2 = opponent_1.closely_matched_opponent
  if rand(1) == 1 #randomize their order?
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
