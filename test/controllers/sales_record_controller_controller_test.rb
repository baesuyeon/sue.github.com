require 'test_helper'

class SalesRecordControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sales_record_controller_index_url
    assert_response :success
  end

  test "should get show" do
    get sales_record_controller_show_url
    assert_response :success
  end

end
