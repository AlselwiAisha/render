require 'test_helper'

class V1::ProductWorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    # objects
    @product_work = product_works(:one)
    @product_work2 = product_works(:two)
    @owner_user = users(:one)
    @employee_user = users(:two)
    @product = products(:one)
    @work = works(:three)
    @shop = shops(:one)

    # jwt payload
    owner_jwt_payload = { sub: @owner_user.id, jti: @owner_user.jti }
    employee_jwt_payload = { sub: @employee_user.id, jti: @employee_user.jti }

    # jwt token
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)

    # headers
    @owner_token_header = { 'Authorization': "Bearer #{@owner_token}" }
    @employee_token_header = { 'Authorization': "Bearer #{@employee_token}" }
    @product_work_id = { 'ProductWorkId': @product_work.id }
    @product_work2_id = { 'ProductWorkId': @product_work2.id }
    @shop_id = { 'ShopId': @shop.id }
  end

  test 'Owner should post create' do
    headers = @owner_token_header.merge(@shop_id)
    post v1_product_works_create_url,
         params: { product_work: { product_id: @product.id, work_id: @work.id, percent: 10 } }, headers:, as: :json
    assert_response :created
    assert_equal 'Product work created successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should post create' do
    headers = @employee_token_header.merge(@shop_id)
    post v1_product_works_create_url,
         params: { product_work: { product_id: @product.id, work_id: @work.id, percent: 10 } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should put update' do
    headers = @owner_token_header.merge(@product_work_id).merge(@shop_id)
    put v1_product_works_update_url, params: { product_work: { percent: 20 } }, headers:, as: :json
    assert_response :success
    assert_equal 'percent updated successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not put update' do
    headers = @employee_token_header.merge(@product_work_id).merge(@shop_id)
    put v1_product_works_update_url, params: { product_work: { percent: 20 } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should delete' do
    headers = @owner_token_header.merge(@product_work2_id).merge(@shop_id)
    delete v1_product_works_delete_url, headers:, as: :json
    assert_response :success
    assert_equal 'Product work removed successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should delete' do
    headers = @employee_token_header.merge(@product_work2_id).merge(@shop_id)
    delete v1_product_works_delete_url, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
