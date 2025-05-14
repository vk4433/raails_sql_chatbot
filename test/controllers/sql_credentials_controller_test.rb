require "test_helper"

class SqlCredentialsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sql_credentials_new_url
    assert_response :success
  end

  test "should get show" do
    get sql_credentials_show_url
    assert_response :success
  end

  test "should get create" do
    get sql_credentials_create_url
    assert_response :success
  end
end
