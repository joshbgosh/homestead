class IndexBattlesWinnersAndLosers < ActiveRecord::Migration
  def self.up
    add_index :battles, :winner_id
    add_index :battles, :loser_id
  end

  def self.down
  end
end
