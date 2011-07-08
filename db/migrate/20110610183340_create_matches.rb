class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :opponent_1_id
      t.integer :opponent_2_id

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
