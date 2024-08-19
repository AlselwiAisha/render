require 'test_helper'

class V1::GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # objects
    @group = groups(:one)
    @owner_user = users(:one)
    @employee_user = users(:two)
    @shop = shops(:one)

    # jwt payload
    owner_jwt_payload = { sub: @owner_user.id, jti: @owner_user.jti }
    employee_jwt_payload = { sub: @employee_user.id, jti: @employee_user.jti }

    # jwt token
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)

    # headers
    @owner_headers = { 'Authorization': "Bearer #{@owner_token}" }
    @employee_headers = { 'Authorization': "Bearer #{@employee_token}" }
    @shop_id = { 'ShopId': @shop.id }
    @group_id = { 'GroupId': @group.id }
  end

  test 'Owner should get index' do
    headers = @owner_headers.merge(@shop_id)

    get v1_groups_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@owner_user.name} groups", JSON.parse(response.body)['message']
  end

  test 'Employee should get index' do
    headers = @employee_headers.merge(@shop_id)

    get v1_groups_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@employee_user.name} groups", JSON.parse(response.body)['message']
  end

  test 'Owner should post create' do
    headers = @owner_headers.merge(@shop_id)
    post v1_groups_create_url, params: { group: { name: 'Samething2' } }, headers:, as: :json
    assert_response :created
    assert_equal 'Group created successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not post create' do
    headers = @employee_headers.merge(@shop_id)
    post v1_groups_create_url, params: { group: { name: 'Samething2' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should put update' do
    headers = @owner_headers.merge(@shop_id).merge(@group_id)
    put v1_groups_update_url, params: { group: { name: 'Samething' } }, headers:, as: :json
    assert_response :success
    assert_equal 'Group updated successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should put update' do
    headers = @employee_headers.merge(@shop_id).merge(@group_id)
    put v1_groups_update_url, params: { group: { name: 'Samething' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
