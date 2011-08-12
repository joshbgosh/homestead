require 'test_helper'

class BattleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "making new close matches errors out properly on empty database" do
    assert_raises Animal::NotEnoughAnimalsLoadedException do
      Battle.make_new_close_match
    end
  end
end
