require 'test_helper'

class V1::ShopsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # objects
    @shop = shops(:one)
    @shop3 = shops(:three)
    @shop1_owner = users(:one)
    @shop1_employee = users(:two)
    @product = products(:one)

    # jwt payload
    owner_jwt_payload = { sub: @shop1_owner.id, jti: @shop1_owner.jti }
    employee_jwt_payload = { sub: @shop1_employee.id, jti: @shop1_employee.jti }

    # tokens
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)

    # headers
    @shop1_owner_header = { 'Authorization': "Bearer #{@owner_token}" }
    @shop1_employee_header = { 'Authorization': "Bearer #{@employee_token}" }
    @shop_header = { 'ShopId': @shop.id.to_s }
    @shop3_header = { 'ShopId': @shop3.id.to_s }
  end

  test 'owner should get index' do
    headers = @shop1_owner_header.merge(@shop_header)
    get v1_user_shops_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@shop1_owner.name} shops", JSON.parse(response.body)['message']
  end

  test 'employee should get index' do
    headers = @shop1_employee_header.merge(@shop_header)
    get v1_user_shops_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@shop1_employee.name} shops", JSON.parse(response.body)['message']
  end

  test 'owner should get show' do
    headers = @shop1_owner_header.merge(@shop_header)
    get v1_user_shop_url, headers:, as: :json
    assert_response :success
    assert_equal @shop.name, JSON.parse(response.body)['shop']['name']
    assert_equal @shop1_owner.name, JSON.parse(response.body)['employees'][0]['name']
    assert_equal @product.name, JSON.parse(response.body)['products'][0]['name']
  end

  test 'employee should get show' do
    headers = @shop1_employee_header.merge(@shop_header)

    get v1_user_shop_url, headers:, as: :json
    assert_response :success
    assert_equal @shop.name, JSON.parse(response.body)['shop']['name']
    assert_equal @shop1_owner.name, JSON.parse(response.body)['employees'][0]['name']
    assert_equal @product.name, JSON.parse(response.body)['products'][0]['name']
  end

  test 'owner should post create' do
    headers = @shop1_owner_header.merge(@shop_header)
    post v1_user_shops_create_url, params: { shop: { name: 'Samething2' } }, headers:, as: :json
    assert_response :created
    assert_equal 'Shop created successfully', JSON.parse(response.body)['message']
  end

  test 'employee should post create' do
    headers = @shop1_employee_header.merge(@shop_header)
    post v1_user_shops_create_url, params: { shop: { name: 'Samething2' } }, headers:, as: :json
    assert_response :created
    assert_equal 'Shop created successfully', JSON.parse(response.body)['message']
  end

  test 'Owner should put update' do
    headers = @shop1_owner_header.merge(@shop_header)
    put v1_user_shop_update_url, params: { shop: { name: 'Samething' } }, headers:, as: :json
    assert_response :success
    assert_equal 'Shop updated successfully', JSON.parse(response.body)['message']
  end

  test 'employee should not put update' do
    headers = @shop1_employee_header.merge(@shop_header)
    put v1_user_shop_update_url, params: { shop: { name: 'Samething' } }, headers:, as: :json
    # puts "RESPONSE: #{JSON.parse(response.body)}"
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should delete shop' do
    headers = @shop1_owner_header.merge(@shop3_header)
    delete v1_user_shop_delete_url, headers:, as: :json
    assert_response :success
    assert_equal 'Shop removed successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not delete shop' do
    headers = @shop1_employee_header.merge(@shop_header)
    delete v1_user_shop_delete_url, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
