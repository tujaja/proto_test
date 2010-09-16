class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|

      t.string   :token,    :null => false, :limit => 100
      t.string   :filename, :null => false, :limit => 50
      t.integer  :width,    :default => 0, :null => false, :limit => 50
      t.integer  :height,   :default => 0, :null => false, :limit => 50
      t.string   :content_type, :default => "unknown", :null => false, :limit => 50
      t.string   :comment,  :default => "no comments", :null => false, :limit => 100

      t.timestamps
    end
  end

  def self.down
    images = Image.find(:all)

    images.each do |image|
      image.destroy
    end

    drop_table :images
  end
end
