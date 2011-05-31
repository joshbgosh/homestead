class Animal < ActiveRecord::Base
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>"}
	
	has_many :wins, :class_name => "Animal"
	has_many :losses, :class_name => "Animal"
	
	def self.random #lets you fight yourself for now...
		ids = connection.select_all("SELECT id FROM animals")
		find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
	end
	
	def self.by_fewest_battles
		Animal.find(:all, :order => 'battles_count ASC')
	end
	
	def random_opponent
		raise "can't find opponent (only one animal in database)" unless Animal.all.count > 0
		
		opponent = Animal.random
		while (self == opponent)
			opponent = Animal.random
		end
		opponent
	end
	
	# needs a rewrite for clarity
	def self.ranked_by_win_percentage
		animals = Animal.all
		animals.sort! do |a,b|
			result = b.win_percentage <=> a.win_percentage
			if result == 0
			    result = b.wins.count <=> a.wins.count #in a tie-breaker, whoever has the most wins, wins!
				if result == 0
					a.losses.count <=> b.losses.count
				else
					result
				end
			else
				result
			end
		end
		animals
	end
	
	def win_percentage
		if self.wins.count == 0
			0
		else
			self.wins.count.to_f / self.battles.count.to_f
		end
	end
	
	#def wins # these are sort of inefficient, but who cares for now.
	#	Battle.where(:winner_id => self.id)
	# end
	
	#def losses
	#	Battle.where(:loser_id => self.id)
	# end
	
	def battles
		self.wins + self.losses
		#Battle.where("winner_id = :id OR loser_id = :id AND winner_id != loser_id", {:id => self.id})
	end
end
