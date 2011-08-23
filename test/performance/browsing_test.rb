require 'test_helper'
require 'rails/performance_test_help'

# Profiling results for each test method are written to tmp/performance.
class BrowsingTest < ActionDispatch::PerformanceTest
  def test_homepage
    puts Animal.all.count.to_s + " is the animal count before!"
    get '/'
    puts Animal.all.count.to_s + " is the animal count!"
  end
end
