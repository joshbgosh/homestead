#!/bin/bash

bundle exec rake db:migrate && bundle exec rake db:seed && bundle exec rails s -p $PORT