# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_3shimeji_1.0_session',
  :secret      => '309c836ca0441a182ece4488699af412fa901567cdef5a5b1faaeb5d06e48bf2fabfaaa56574aedc14d9b63ebcec0570c3e06474ae12290b2c4e0332fd8c100e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
