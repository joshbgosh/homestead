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
  
  test "adding comments to matches doesn't bork the username on the comment" do
    u = create(:user)
    u.id
    @m.id
    comment_params = attributes_for(:comment, :commentable_id => @m.id,
     :user_id => u.id)
    comment = @m.comments.create(comment_params)
      #@match.add_comment(comment) #hopefully this isn't necessary, due to the commentable_id and commentable_type being correct
    assert_equal comment.user_name, u.username
  end
  
end