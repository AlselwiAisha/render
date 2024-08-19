require 'test_helper'

class V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    # objects
    @owner = users(:one)
    @employee = users(:two)
    @shop = shops(:one)

    # jwt_payloads
    owner_jwt_payload = { sub: @owner.id, jti: @owner.jti }
    employee_jwt_payload = { sub: @employee.id, jti: @employee.jti }

    # tokens
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @header_of_owner_user = { 'Authorization': "Bearer #{@owner_token}" }

    # headers
    @header_of_owner_user = { 'Authorization': "Bearer #{@owner_token}" }
    @header_of_employee_user = { 'Authorization': "Bearer #{@employee_token}" }
    @header_of_shop = { 'ShopId': @shop.id.to_s }
  end

  test 'user should login user' do
    post v1_user_session_url,
         params: { user: { email: @owner.email, password: '654321' } }, as: :json

    assert_response :success
    assert_not_nil response.body['head']
    assert_equal @owner.email, JSON.parse(response.body)['email']
    assert_equal 'Logged in successfully.', JSON.parse(response.body)['message']
  end

  test 'owner should create a new user' do
    headers = @header_of_owner_user.merge(@header_of_shop)
    post v1_users_create_url,
         params: { user: { name: 'Ibrahem', password: '123456',
                           password_confirmation: '123456',
                           email: 'ibrahem@mail.com', address: 'somewhere', phone: 'number' } }, headers:, as: :json
    assert_response :created
  end

  test 'user should log out' do
    headers = { 'Authorization': " #{@owner_token}" }
    delete destroy_v1_user_session_url, headers:, as: :json
    assert_response :success
    assert_equal 'Logged out successfully.', JSON.parse(response.body)['message']
  end

  test 'user should update self account' do
    headers = @header_of_owner_user
    put v1_user_registration_url, params: { user: { name: 'AAAAA', current_password: '654321',
                                                    password: '123456', password_confirmation: '123456' } },
                                  headers:, as: :json
    assert_response :success
    assert_equal 'Successfully updated.', JSON.parse(response.body)['message']
  end

  test 'employee Should not create a user' do
    headers = @header_of_employee_user.merge(@header_of_shop)
    post v1_users_create_url,
         params: { user: { name: 'hemo', password: '123456',
                           password_confirmation: '123456',
                           email: 'hemo@mail.com', address: 'somewhere', phone: 'number' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
