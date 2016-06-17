require 'test_helper'

class MailerControllerTest < ActionController::TestCase
  test "should get contact_us_mailer" do
    get :contact_us_mailer
    assert_response :success
  end

end
