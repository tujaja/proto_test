class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string  :status,        :default => 'created', :null => false
      t.string  :payment_type,  :default => 'free',  :null => false
      t.integer :amount,        :default => '0', :null => false

      t.string  :email
      t.string  :first_name
      t.string  :last_name

      t.string  :paypal_email
      t.string  :paypal_first_name
      t.string  :paypal_last_name
      t.string  :paypal_cancel_url
      t.string  :paypal_return_url
      t.string  :paypal_payer_id
      t.string  :paypal_token

    end
  end

  def self.down
    drop_table :payments
  end
end
