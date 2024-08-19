require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Objects
    @owner_user = users(:one)
    @employee_user = users(:two)
    @shop = shops(:one)
    @product = products(:one)
    @prototype = prototypes(:one)

    # jwt payload
    owner_jwt_payload = { sub: @owner_user.id, jti: @owner_user.jti }
    employee_jwt_payload = { sub: @employee_user.id, jti: @employee_user.jti }

    # jwt token
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)

    # headers
    @owner_token_header = { 'Authorization': "Bearer #{@owner_token}" }
    @employee_token_header = { 'Authorization': "Bearer #{@employee_token}" }
    @product_id = { 'ProductId': @product.id.to_s }
    @shop_id = { 'ShopId': @shop.id.to_s }
  end
  test 'Owner should get index' do
    headers = @owner_token_header.merge(@shop_id)
    get v1_products_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@shop.name} products", JSON.parse(response.body)['message']
  end

  test 'Employee should get index' do
    headers = @employee_token_header.merge(@shop_id)
    get v1_products_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@shop.name} products", JSON.parse(response.body)['message']
  end

  test 'Owner should get show' do
    headers = @owner_token_header.merge(@product_id).merge(@shop_id)
    get v1_product_url, headers:, as: :json
    assert_response :success
    assert_equal @product.name, JSON.parse(response.body)['name']
  end

  test 'Employee should get show' do
    headers = @employee_token_header.merge(@product_id).merge(@shop_id)
    get v1_product_url, headers:, as: :json
    assert_response :success
    assert_equal @product.name, JSON.parse(response.body)['name']
  end

  test 'Owner should post create' do
    headers = @owner_token_header.merge(@shop_id)
    post v1_products_create_url, params: { product: { name: 'sameer', price: 0.99, prototype_id: @prototype.id, shop_id: @shop.id } }, headers:,
                                 as: :json
    assert_response :success
    assert_equal 'Product created successfully', JSON.parse(response.body)['message']
    assert_equal 'sameer', JSON.parse(response.body)['product']['name']
  end

  test 'Employee should not post create' do
    headers = @employee_token_header.merge(@shop_id)
    post v1_products_create_url, params: { product: { name: 'sameer', price: 0.99, prototype_id: @prototype.id, shop_id: @shop.id } }, headers:,
                                 as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should put update' do
    headers = @owner_token_header.merge(@product_id).merge(@shop_id)
    put v1_products_update_url,  params: { product: { name: 'sundus', price: 0.99 } }, headers:,
                                 as: :json
    assert_response :success

    assert_equal 'Product updated successfully', JSON.parse(response.body)['message']
    assert_equal 'sundus', JSON.parse(response.body)['product']['name']
  end

  test 'Employee should not put update' do
    headers = @employee_token_header.merge(@product_id).merge(@shop_id)
    put v1_products_update_url,  params: { product: { name: 'sundus', price: 0.99 } }, headers:,
                                 as: :json
    assert_response :forbidden

    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should delete product' do
    prototype_count = Prototype.all.length
    group_count = Group.all.length
    headers = @owner_token_header.merge(@product_id).merge(@shop_id)
    delete v1_products_delete_url, headers:, as: :json
    assert_response :success
    assert_equal 'Product removed successfully', JSON.parse(response.body)['message']
    assert_equal 1, Prototype.all.length
    assert_equal 1, Group.all.length
  end
  test 'Employee should delete product' do
    headers = @employee_token_header.merge(@product_id).merge(@shop_id)
    delete v1_products_delete_url, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
