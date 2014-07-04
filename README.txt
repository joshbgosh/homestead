Things you might need to do to get this up and running:

Populate DB with admin username and password:
  bundle exec rake db:seed

bundle install
bundle exec rake db:migrate
bundle exec rails server

Currently set up to use ruby 1.9.3 via rvm. 
Rvm should point to the 'test' gemset for 1.9.3 on localhost

Run the script to minify all the CSS and Javascript