#!/bin/bash
echo "system specified port is ${PORT}"
if [[ -z ${PORT} ]]; then 
	export PORT=3000
	echo "assigning default port ${PORT}"
else
	echo "using system specified port ${PORT}"
	PORT=${PORT}
fi
echo "PORT variable used is now ${PORT}"
bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed && bundle exec jammit && bundle exec rails s -p ${PORT}