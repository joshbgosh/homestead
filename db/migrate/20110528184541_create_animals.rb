class CreateAnimals < ActiveRecord::Migration
  def self.up
    create_table :animals do |t|
      t.string :name
      t.timestamps
	  t.string :image_file_name
	  t.string :image_content_type
	  t.integer :image_file_size
	  t.datetime :image_updated_at
	  
	  t.integer :wins_count # TODO: are these being used?
	  t.integer :losses_count
    end
  end

  def self.down
    drop_table :animals
  end
end
