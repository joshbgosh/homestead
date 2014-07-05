require 'test_helper'

class AnimalTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "animal images have width and height" do
    a = build(:animal)
    assert a.image.width
    assert a.image.height
  end
  
end
