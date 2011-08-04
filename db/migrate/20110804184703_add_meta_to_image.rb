class AddMetaToImage < ActiveRecord::Migration
  def self.up
    add_column :animals, :image_meta,    :text
  end

  def self.down
    remove_column :animals, :image_meta
  end
end
