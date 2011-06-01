class Animal < ActiveRecord::Base
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>"}
	
	has_many :wins, :class_name => "Battle", :foreign_key => "winner_id"
	has_many :losses, :class_name => "Battle", :foreign_key => "loser_id"
	
	def self.random #lets you fight yourself for now...
		ids = connection.select_all("SELECT id FROM animals")
		find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
	end
	
	def random_opponent
    raise "can't find opponent (only one animal in database)" unless Animal.all.count > 0
    
    opponent = Animal.random
    while (self == opponent)
      opponent = Animal.random
    end
    opponent
  end
	
	def self.by_fewest_battles
		Animal.all.sort!{|a,b| a.battles.count <=> b.battles.count}
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
	
	def arch_nemesis #beats me the most (TODO: clean this method up)
	  enemies_lost_to = Animal.find_by_sql(["SELECT winner_id, COUNT(*)
	                      FROM animals JOIN battles ON loser_id = ?
	                      GROUP BY winner_id
	                      ORDER BY COUNT(*) DESC", self.id])
	  if enemies_lost_to.count > 0
	    arch_nemesis_id = enemies_lost_to[0].winner_id
	    Animal.find(arch_nemesis_id)
	  else
	    nil
	  end                 
	end
	
	def defeats_by(opponent)
	  Battle.where(:winner_id => opponent.id, :loser_id => self.id)
	end
	
	def enemies_by_my_losses
	
	end
	
	def worthy_opponent #the opponent I am most closely matched with
	end
	
	def dominates #I beat this the most
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
