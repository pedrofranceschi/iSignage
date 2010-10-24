require 'test_helper'

class IdeviceControllerTest < ActionController::TestCase
  
  setup do
    # @request.user_agent = "blah"
    User.new(:username => "testuser", :password => "testpassword", :full_name => "Test User", :email => "test@user.com").save
  end
  
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "should not respond to other user agents" do 
    user_agent = "blah"
    post '/idevice/login', {:username => "testuser", :password => "testpassword"}
    assert_response 401
  end
    
end
