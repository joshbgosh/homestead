class RenameBattlesToBallots < ActiveRecord::Migration
  def self.up
    rename_table :battles, :ballots
  end

  def self.down
    rename_table :ballots, :battles
  end
end
