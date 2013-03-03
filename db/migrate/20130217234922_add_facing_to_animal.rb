class AddFacingToAnimal < ActiveRecord::Migration
  def self.up
    add_column :animals, :facing, :varchar, :default => "Right"
  end

  def self.down
    remove_column :animals, :facing
  end
end
