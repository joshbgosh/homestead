class Battle < ActiveRecord::Base
belongs_to :winner, :class_name => "Animal" #, :foreign_key => "winner_id"
belongs_to :loser,  :class_name => "Animal" #, :foreign_key => "loser_id"

	def battles
		Battle.find(:conditions => ["winner_id = ? OR loser_id = ?", id, id])
	end
end
