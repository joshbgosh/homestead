class AddFacingToAnimal < ActiveRecord::Migration
  def self.up
    add_column :animals, :facing, :varchar
  end

  def self.down
    remove_column :animals, :facing
  end
end
