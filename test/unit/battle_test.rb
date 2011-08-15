require 'test_helper'

class BattleTest < ActiveSupport::TestCase
  
  test "if you create a battle that has no match yet, it will make one" do
    a1 = create(:animal)
    a2 = create(:animal)
    b = Battle.create(:winner => a1, :loser => a2)
    
    assert_not_nil b.match
  end
  
  test "making new close matches errors out properly on empty database" do
    assert_raises Animal::NotEnoughAnimalsLoadedException do
      Battle.make_new_close_match
    end
  end
  
  test "getting stats on a battle with no other judgements" do 
    b = create(:battle)
    stats = b.stats
    
    assert BattleStats::NoPriorVotes === stats
  end
  
  test "getting stats on a battle with some previous judgements" do
    a1 = create(:animal)
    a2 = create(:animal)
    
    Battle.create(:winner => a1, :loser => a2)
    Battle.create(:winner => a1, :loser => a2)
    Battle.create(:winner => a1, :loser => a2)
    Battle.create(:winner => a2, :loser => a1)
    last_battle = Battle.create(:winner => a2, :loser => a1)
    
    stats = last_battle.stats
    
    assert BattleStats::PriorVotes === stats
    assert_equal a2, stats.user_picked
    assert_equal 25, stats.percent_agreed
    assert_equal 75, stats.percent_disagreed
  end
end
