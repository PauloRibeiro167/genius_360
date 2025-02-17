require "test_helper"

class Admin::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_pages_index_url
    assert_response :success
  end
end
