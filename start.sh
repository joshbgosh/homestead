#!/bin/bash

bundle exec rake db:migrate && bundle exec rake db:seed --trace && bundle exec rails s -p $PORT