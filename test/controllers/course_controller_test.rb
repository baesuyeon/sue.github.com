require 'test_helper'

class CourseControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get course_show_url
    assert_response :success
  end

end
