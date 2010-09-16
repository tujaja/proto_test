class InitialUser < ActiveRecord::Migration
  def self.up
    login = 'eita'
    email = 'eita@gmail.com'
    pass = 'eitaeita'
    pass_confirm = 'eitaeita'

    eita = User.new(:login => login, :email => email, :password => pass, :password_confirmation => pass_confirm)

    eita.save
  end

  def self.down
  end
end
