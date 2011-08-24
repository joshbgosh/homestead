require 'fileutils'
 
task :profile do
  FileUtils.mv Dir.glob("#{Rails.root}/test/fixtures_for_performance/*.yml"), "#{Rails.root}/test/fixtures/"
  
  FileUtils.cp "#{Rails.root}/config/environments/test.rb", "#{Rails.root}/config/environments/test_backup.rb"
  FileUtils.cp "#{Rails.root}/config/environments/performance.rb", "#{Rails.root}/config/environments/test.rb"
  
  #FileUtils.cp "#{Rails.root}/db/performance_backup.sqlite3", "#{Rails.root}/db/performance.sqlite3"
  
  Rake::Task['test:profile'].execute
  
  FileUtils.cp "#{Rails.root}/config/environments/test_backup.rb", "#{Rails.root}/config/environments/test.rb" 
  
  FileUtils.mv Dir.glob("#{Rails.root}/test/fixtures/*.yml"), "#{Rails.root}/test/fixtures_for_performance/" 
end

task :profileergerg => :environment do
  
  FileUtils.cp "#{Rails.root}/config/environments/test.sqlite3", "#{Rails.root}/db/test_backup.sqlite3"
  
  FileUtils.cp "#{Rails.root}/db/test.sqlite3", "#{Rails.root}/db/test_backup.sqlite3"
  FileUtils.cp "#{Rails.root}/db/performance.sqlite3", "#{Rails.root}/db/test.sqlite3"
  
  Rake::Task['test:profile'].execute  
  
  FileUtils.cp "#{Rails.root}/db/test_backup.sqlite3", "#{Rails.root}/db/test.sqlite3"
end

task :benchmarkegerg do
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