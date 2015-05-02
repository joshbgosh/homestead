#!/bin/bash
if [[ -z $PORT ]];
	then PORT=3000;
fi
bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed --trace && bundle exec rails s -p $PORT