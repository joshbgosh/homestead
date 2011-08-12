require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  setup do
    @m = create(:match)
  end
  
  teardown do
    @m.destroy
  end
  
  test "adding comments to matches" do
     assert_equal @m.comments.count, 0
     c = create(:comment, :commentable_id => @m.id)
     assert_equal @m.comments.count, 1
  end
  
end