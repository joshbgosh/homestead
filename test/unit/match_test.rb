require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  
  setup do
    @a1 = create(:animal)
    @a2 = create(:animal)
    @a3 = create(:animal)
  end
  
  teardown do
    @a1.destroy
    @a2.destroy
    @a3.destroy
  end
  
  test "finding matches" do
    m = Match.create(:opponent_1 => @a1, :opponent_2 => @a2)
    assert Match.find_with(@a1, @a2)
  end
  
  test "getting existing matches" do
    assert_equal(Match.get_or_create_with(@a1, @a2).id, Match.get_or_create_with(@a1, @a2).id)
  end
  
  test "getting/creating a new match" do
    id1 = Match.get_or_create_with(@a1, @a2).id
    id2 = Match.get_or_create_with(@a1, @a3).id
    
    assert_not_equal id1, id2
     #to make sure they aren't the same match
  end
  
  test "that order isn't significant when getting/creating matches" do
    assert_equal(Match.get_or_create_with(@a1, @a2).id, Match.get_or_create_with(@a1, @a2).id)
  end
  
end
