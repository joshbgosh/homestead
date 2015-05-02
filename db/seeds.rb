# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

ADMIN_USERNAME = ENV["TOTALLYENRAGED_ADMIN_USERNAME"]
ADMIN_PASSWORD = ENV["TOTALLYENRAGED_ADMIN_PW"]

admin_accounts_that_look_like_me = Admin.where(:username => ADMIN_USERNAME)

if admin_accounts_that_look_like_me.count == 0
  my_admin_account = Admin.create! do |a|
    a.username = ADMIN_USERNAME
    a.password = ADMIN_PASSWORD
    a.password_confirmation = ADMIN_PASSWORD
  end
  puts "created admin account"
else
  #admin account already created. Nothing to do.
  puts "admin account already exists in database. Skipped admin account creation"
end
