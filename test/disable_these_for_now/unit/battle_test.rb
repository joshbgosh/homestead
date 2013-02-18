require 'test_helper'

class BallotTest < ActiveSupport::TestCase
  
  test "if you create a ballot that has no match yet, it will make one" do
    a1 = create(:animal)
    a2 = create(:animal)
    b = Ballot.create(:winner => a1, :loser => a2)
    
    assert_not_nil b.match
  end
  
  test "making new close matches errors out properly on empty database" do
    assert_raises Animal::NotEnoughAnimalsLoadedException do
      Ballot.make_new_close_match
    end
  end
  
  test "getting stats on a ballot with no other judgements" do 
    b = create(:ballot)
    stats = b.stats
    
    assert BallotStats::NoPriorVotes === stats
  end
  
  test "getting stats on a ballot with some previous judgements" do
    a1 = create(:animal)
    a2 = create(:animal)
    
    Ballot.create(:winner => a1, :loser => a2)
    Ballot.create(:winner => a1, :loser => a2)
    Ballot.create(:winner => a1, :loser => a2)
    Ballot.create(:winner => a2, :loser => a1)
    last_ballot = Ballot.create(:winner => a2, :loser => a1)
    
    stats = last_ballot.stats
    
    assert BallotStats::PriorVotes === stats
    assert_equal a2, stats.user_picked
    assert_equal 25, stats.percent_agreed
    assert_equal 75, stats.percent_disagreed
  end
end
