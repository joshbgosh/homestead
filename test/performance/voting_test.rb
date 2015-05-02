require 'test_helper'
require 'rails/performance_test_help'

# Profiling results for each test method are written to tmp/performance.
class VotingTest < ActionDispatch::PerformanceTest
  def test_voting_multiple_times_in_a_row
    10.times do
      get '/'
    end
  end
  
  def test_getting_from_scratch_then_voting
    t
    get '/'
    
    10.times do
      one_of_the_animals_id = assigns(:ballot).match.opponent_1.id
      post '/ballots/', :winner_id => one_of_the_animals_id.to_s
    end
  end
end
