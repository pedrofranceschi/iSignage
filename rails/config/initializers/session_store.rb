# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_isignage_rails_session',
  :secret      => '154f3449014fd4f7a674af64baceee0ed4ec219d2624e3bdbdf6be1947673af52c9e2666b1cd2eb01e3fc909e393959b98618da288e25097a4e6695d83f42eae'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
