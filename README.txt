Things you might need to do to get this up and running:

Run 'start.sh' on OS X or Linux to start server

The default admin username/pw is "admin" and "changeme", but in any serious environment you should set the variables (TOTALLYENRAGED_ADMIN_USERNAME, TOTALLYENRAGED_ADMIN_PW) to something else.

Populate DB with admin username and password:
  bundle exec rake db:seed

Currently set up to use ruby 1.9.3 via rvm. 
Rvm should point to the 'test' gemset for 1.9.3 on localhost

You may need imagemagick to be installed locally (this is used for manipulating images of animals that are uploaded.) See the documentation around the Paperclip gem for this.

See the deploy_* scripts for deploying to Bluemix and Heroku. You will need to bind postgresql databases to each instance by hand in Bluemix for this to work (currently you can do this with the experimental postgresql service, or the elephantsql service.)



