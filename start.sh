#!/bin/bash
echo $PORT
if [[ -z ${PORT} ]]
	then export PORT=3000;
else
	PORT=${PORT}
fi
bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed && bundle exec jammit && bundle exec rails s -p ${PORT}