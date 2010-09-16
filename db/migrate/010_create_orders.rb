class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|

      t.string  :token,  :limit => 50, :null => false

      t.string  :email
      t.string  :first_name
      t.string  :last_name
      t.string  :payment_type

      t.datetime :order_time

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
