require "test_helper"

class Public::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_pages_index_url
    assert_response :success
  end
end
