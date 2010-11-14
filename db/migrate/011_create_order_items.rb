class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.string  :token,  :limit => 50, :null => false
      t.integer :order_id,    :default => 0, :null => false
      t.integer :content_id,  :default => 0, :null => false
      t.integer :quantity,    :default => 0, :null => false
      t.integer :download_count,    :default => 3

      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
