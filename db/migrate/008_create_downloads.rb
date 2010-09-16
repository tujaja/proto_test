class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|

      t.string   :token,    :null => false, :limit => 100
      t.string   :filename,     :null => false, :limit => 50
      t.integer  :size,         :default => 0, :null => false, :limit => 10
      t.string   :content_type, :default => "unknown", :null => false, :limit => 50
      t.string   :comment,  :default => "no comments", :null => false, :limit => 100

      t.timestamps
    end
  end

  def self.down
    dls = Download.find(:all)

    dls.each do |dl|
      dl.destroy
    end

    drop_table :downloads
  end
end
