require 'test_helper'

class V1::ShopEmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Objects
    @user1_shop1_owner = shop_employees(:user1_shop1_owner)
    @user2_shop1_employee = shop_employees(:user2_shop1_employee)
    @user3_shop1_employee = shop_employees(:user3_shop1_owner)
    @shop1 = shops(:one)
    @shop2 = shops(:two)
    @shop3 = shops(:three)
    @owner_user = users(:one)
    @employee_user = users(:two)
    @user3 = users(:three)
    @user4 = users(:four)

    # jwt payload
    owner_jwt_payload = { sub: @owner_user.id, jti: @owner_user.jti }
    employee_jwt_payload = { sub: @employee_user.id, jti: @employee_user.jti }

    # jwt token
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)

    # headers
    @owner_token_header = { 'Authorization': "Bearer #{@owner_token}" }
    @employee_token_header = { 'Authorization': "Bearer #{@employee_token}" }
    @shop1_header = { 'ShopId': @shop1.id.to_s }
    @shop_employee_header = { 'ShopEmployeeId':  @user1_shop1_owner.id.to_s }
    @shop_employee2_header = { 'ShopEmployeeId': @user2_shop1_employee.id.to_s }
    @shop_employee3_header = { 'ShopEmployeeId': @user3_shop1_employee.id.to_s }
  end

  test 'Owner should post create' do
    headers = @owner_token_header.merge(@shop1_header)
    post v1_user_shops_employees_create_url,
         params: { shop_employee: { user_id: @user4.id, shop_id: @shop1.id, role: 'employee' } }, headers:, as: :json
    assert_response :created
    assert_equal "Added #{@user4.name} as an #{ShopEmployee.last.role}", JSON.parse(response.body)['message']
  end

  test 'Employee should not post create' do
    headers = @employee_token_header.merge(@shop1_header)
    post v1_user_shops_employees_create_url,
         params: { shop_employee: { user_id: @owner_user.id, shop_id: @shop3.id, role: 'owner' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should put update' do
    headers = @owner_token_header.merge(@shop_employee2_header).merge(@shop1_header)
    put v1_user_shops_employees_update_url, params: { shop_employee: { role: 'owner' } }, headers:, as: :json
    assert_response :success
    assert_equal 'employee updated successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not put update' do
    headers = @employee_token_header.merge(@shop_employee2_header).merge(@shop1_header)
    put v1_user_shops_employees_update_url, params: { shop_employee: { role: 'owner' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should delete' do
    headers = @owner_token_header.merge(@shop_employee3_header).merge(@shop1_header)
    delete v1_user_shops_employees_delete_url, headers:, as: :json
    assert_response :success
    assert_equal 'Employee removed successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not delete' do
    headers = @employee_token_header.merge(@shop_employee2_header).merge(@shop1_header)
    delete v1_user_shops_employees_delete_url, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
