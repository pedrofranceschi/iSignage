require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "should not create user with nil data" do
    assert (User.new().save == false)
  end
  
end
