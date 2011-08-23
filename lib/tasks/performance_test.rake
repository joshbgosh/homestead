require 'fileutils'
 
task :profile => :environment do
  
  FileUtils.cp "#{Rails.root}/config/environments/test.sqlite3", "#{Rails.root}/db/test_backup.sqlite3"
  
  FileUtils.cp "#{Rails.root}/db/test.sqlite3", "#{Rails.root}/db/test_backup.sqlite3"
  FileUtils.cp "#{Rails.root}/db/performance.sqlite3", "#{Rails.root}/db/test.sqlite3"
  
  Rake::Task['test:profile'].execute  
  
  FileUtils.cp "#{Rails.root}/db/test_backup.sqlite3", "#{Rails.root}/db/test.sqlite3"
end

task :benchmark do
  FileUtils.rm "#{Rails.root}/db/test.sqlite3"
  FileUtils.cp "#{Rails.root}/db/performance.sqlite3", "#{Rails.root}/db/test.sqlite3"
  Rake::Task['test:profile'].execute  
end

task :benchmark_test do
  ENV["RAILS_ENV"] = "performance"
  FileUtils.rm "#{Rails.root}/db/performance.sqlite3"
  FileUtils.cp "#{Rails.root}/db/performance_backup.sqlite3", "#{Rails.root}/db/performance.sqlite3"
  Rake::Task['test:benchmark'].execute  
end
 
task :profile_test_old do
  ENV["RAILS_ENV"] = "performance"
  FileUtils.rm "#{Rails.root}/db/performance.sqlite3"
  FileUtils.cp "#{Rails.root}/db/performance_backup.sqlite3", "#{Rails.root}/db/performance.sqlite3"
  Rake::Task['test:profile'].execute  
end

task :benchmark_test_old do
  ENV["RAILS_ENV"] = "performance"
  FileUtils.rm "#{Rails.root}/db/performance.sqlite3"
  FileUtils.cp "#{Rails.root}/db/performance_backup.sqlite3", "#{Rails.root}/db/performance.sqlite3"
  Rake::Task['test:benchmark'].execute  
end