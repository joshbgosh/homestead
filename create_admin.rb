ADMIN_USERNAME = "mlinnem"
ADMIN_PASSWORD = "changeme" #TODO: best to not have this when it comes time for production.
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