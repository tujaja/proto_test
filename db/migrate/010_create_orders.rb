class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|

      t.string  :token,   :null => false, :limit => 50
      t.string  :email,   :null => false, :limit => 50
      t.string  :payment_type,   :null => false, :limit => 20
      t.string  :status,  :default => 'pending', :null => false, :limit => 20

      t.datetime :order_time
      t.datetime :expire_time

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
