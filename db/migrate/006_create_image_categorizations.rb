class CreateImageCategorizations < ActiveRecord::Migration
  def self.up
    create_table :image_categorizations do |t|
      t.integer :image_id

      t.integer :priority, :default => 0
      t.integer :owner_id
      t.string  :owner_type

      t.timestamps
    end
  end

  def self.down
    drop_table :image_categorizations
  end
end
