require 'test_helper'
require 'rails/performance_test_help'

# Profiling results for each test method are written to tmp/performance.
class BrowsingTest < ActionDispatch::PerformanceTest
  def test_getting_a_new_battle_from_scratch
    10.times do
      get '/'
    end
  end
  
  def test_getting_from_scratch_then_voting
    
    get '/'
    
    10.times do
      one_of_the_animals_id = assigns(:battle).match.opponent_1.id
      post '/battles/', :winner_id => one_of_the_animals_id.to_s
    end
  end
end
