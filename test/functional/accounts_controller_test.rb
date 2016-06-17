require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, account: { address_city: @account.address_city, address_state: @account.address_state, address_street: @account.address_street, address_zip: @account.address_zip, company_name: @account.company_name, company_website: @account.company_website, name: @account.name, phone_home: @account.phone_home, phone_mobile: @account.phone_mobile, phone_work: @account.phone_work }
    end

    assert_redirected_to account_path(assigns(:account))
  end

  test "should show account" do
    get :show, id: @account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @account
    assert_response :success
  end

  test "should update account" do
    put :update, id: @account, account: { address_city: @account.address_city, address_state: @account.address_state, address_street: @account.address_street, address_zip: @account.address_zip, company_name: @account.company_name, company_website: @account.company_website, name: @account.name, phone_home: @account.phone_home, phone_mobile: @account.phone_mobile, phone_work: @account.phone_work }
    assert_redirected_to account_path(assigns(:account))
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, id: @account
    end

    assert_redirected_to accounts_path
  end
end
