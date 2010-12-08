class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string  :token,        :null => false, :limit => 50
      t.string  :domain,       :null => false, :limit => 30
      t.boolean :activated,    :null => false, :default => false

      t.string  :name,         :null => false, :limit => 30
      t.string  :subname,      :default => "", :limit => 30
      t.integer :price,        :default => 0, :null => false, :limit => 10
      t.text    :description,  :defaule => "", :limit => 500
      t.integer :sales,        :default => 0, :null => false, :limit => 20
      t.integer :download_counts, :default => 0, :null => false, :limit => 20

      t.integer :artist_id,    :null => false # belongs_to :artist
      t.integer :attachable_info_id # belongs_to :attachable_info (polymorphic)
      t.string  :attachable_info_type
      t.integer :primary_image_id


      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
