class Animal < ActiveRecord::Base
  
	has_attached_file :image, 
	  {:styles => { :large => "300x300>", :medium => "250x250", :thumb => "150x150>"},
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
	  
	  
	
	has_many :matches
	
	has_many :wins, :class_name => "Battle", :foreign_key => "winner_id"
	has_many :losses, :class_name => "Battle", :foreign_key => "loser_id"
	
	def battles
    self.wins + self.losses
  end
  
  def wins_against(opponent)
    Battle.where(:winner_id => self.id, :loser_id => opponent.id)
  end
  
  def defeats_by(opponent)
    Battle.where(:winner_id => opponent.id, :loser_id => self.id)
  end
  
  def win_percentage
    if self.wins.count == 0
      0
    else
      self.wins.count.to_f / self.battles.count.to_f
    end
  end
  
	def random_opponent
    raise NotEnoughAnimalsLoadedException, "can't find an opponent (only one animal in database)" unless Animal.all.count > 1
    
    opponent = Animal.random
    while (self == opponent)
      opponent = Animal.random()
    end
    opponent
  end
	
	def closely_matched_opponent #TODO: should be cleaned up
	  raise NotEnoughAnimalsLoadedException, "can't find opponent (only one animal in database)" unless Animal.all.count > 1
	  
	  
	  animals_ranked_by_win_percentage = Animal.ranked_by_win_percentage
	  
	  def neighbors(a, index, distance)
	    from = [index - distance, 0].max
	    to = [index + distance, a.length - 1].min
	    neighbors = []
	    (from..to).each do |i| 
	      if i != index 
	        neighbors.push(a[i]) 
	      end
	    end
	    neighbors
	  end 
	  
	  my_index = animals_ranked_by_win_percentage.index(self)
	  distance = 3
	  nearby_opponents = neighbors(animals_ranked_by_win_percentage, my_index, 3);
	  closely_matched_opponent = nearby_opponents[rand(nearby_opponents.length)]
	end
	
	def arch_nemesis #beats me the most
    enemies_lost_to_records = Animal.find_by_sql(["SELECT winner_id, COUNT(*)
                        FROM animals JOIN battles ON loser_id = ?
                        GROUP BY winner_id
                        ORDER BY COUNT(*) DESC", self.id])
    if enemies_lost_to_records.count > 0
      arch_nemesis_id = enemies_lost_to_records[0].winner_id
      Animal.find(arch_nemesis_id)
    else
      nil
    end                 
  end
  
  @@TOLERABLE_WINS_RATIO = 10/1 #otherwise you don't count as 'dominating' that animal
  
  def dominates #who I beat the most, with minimal losses (TODO: needs optimization)
    enemies_beaten_records = Animal.find_by_sql(["SELECT loser_id AS \"id\", COUNT(*)
                        FROM animals JOIN battles ON winner_id = ?
                        GROUP BY loser_id
                        ORDER BY COUNT(*) DESC", self.id])
    
    if enemies_beaten_records.count > 0
      fewest_losses_enemy_id = enemies_beaten_records[0].id
      fewest_losses = self.defeats_by(Animal.find(fewest_losses_enemy_id)).count
      enemies_beaten_records.each do |current_enemy_record|
        if fewest_losses == 0
          return Animal.find(fewest_losses_enemy_id)
        else
          current_enemy_losses = self.defeats_by(Animal.find(current_enemy_record.id)).count
          if fewest_losses <= current_enemy_losses
            next
          else
            fewest_losses = current_enemy_losses
            fewest_losses_enemy_id = current_enemy_record.id
            next
          end
        end
      end
    
      if ((fewest_losses * @@TOLERABLE_WINS_RATIO) > self.wins_against(Animal.find(fewest_losses_enemy_id)).count) 
        #if we haven't beaten this animal at least 10 to 1, don't even bother
        nil
      else
        Animal.find(fewest_losses_enemy_id)
      end
    else
      nil
    end      
  end
	
	def self.random
	  raise NotEnoughAnimalsLoadedException, "Couldn't find a random animal, since there are no animals in the database" unless Animal.count > 0
    
    ids = connection.select_all("SELECT id FROM animals")
    find(ids[rand(ids.length)]["id"].to_i) 
  end
  
  def self.by_fewest_battles
    Animal.all.sort!{|a,b| a.battles.count <=> b.battles.count}
  end
  
  #TODO: needs a rewrite for clarity
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

  class NotEnoughAnimalsLoadedException < Exception; end
end
