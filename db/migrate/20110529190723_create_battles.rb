class CreateBattles < ActiveRecord::Migration
  def self.up
    create_table :battles do |t|
      t.integer :winner_id
      t.integer :loser_id

      t.timestamps
    end
  end

  def self.down
    drop_table :battles
  end
end
