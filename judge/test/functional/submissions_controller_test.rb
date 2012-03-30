require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
  test "should get judge" do
    get :judge
    assert_response :success
  end

end
