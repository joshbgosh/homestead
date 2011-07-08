require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "finding matches" do
    assert a1 = Animal.find(1)
    assert a2 = Animal.find(2)
    assert Match.find_with(a1, a2)
  end
  
  test "getting existing matches" do
    assert a1 = Animal.find(1)
    assert a2 = Animal.find(2)
    assert_equal(Match.get_or_create_with(a1, a2).id, Match.find(1).id)
  end
  
  test "getting/creating a new match" do
    assert a1 = Animal.find(1)
    assert a2 = Animal.find(4)
    
    id = Match.get_or_create_with(a1, a2).id
    
    assert (id != 4 and id != 3 and id != 2 and id != 1) #so it must be a new match
  end
  
  test "that order isn't significant when getting/creating matches" do
    assert a1 = Animal.find(1)
    assert a2 = Animal.find(4)
    
    assert_equal(Match.get_or_create_with(a1, a2).id, Match.get_or_create_with(a1, a2).id)
  end
  
  test "matches have the expected number of comments" do
    assert a1 = Animal.find(1)
    assert a2 = Animal.find(2)
    
    assert m1 = Match.get_or_create_with(a1, a2)
    assert_equal(2, m1.comments.count)
  end
  
  test "adding comments to matches" do
    assert a1 = Animal.find(1)
    assert a2 = Animal.find(2)
    
    assert m1 = Match.get_or_create_with(a1, a2)
    
    c1 = Comment.new
    c1.comment = "sup?"
    c1.commentable_id = m1.id
    c1.commentable_type = "match"
    m1.add_comment(c1)
    
    assert_equal(3, m1.comments.count)
  end
end
