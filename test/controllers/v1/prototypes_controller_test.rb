require 'test_helper'

class V1::PrototypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Objects
    @owner_user = users(:one)
    @employee_user = users(:two)
    @group = groups(:one)
    @shop = shops(:one)
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
    @prototype_header = { 'PrototypeId': @prototype.id.to_s }
    @shop_header = { 'ShopId': @shop.id.to_s }
  end

  test 'Owner should get index' do
    headers = @owner_token_header.merge(@shop_header)
    get v1_prototypes_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@owner_user.name} prototypes", JSON.parse(response.body)['message']
  end

  test 'Employee should get index' do
    headers = @employee_token_header.merge(@shop_header)
    get v1_prototypes_url, headers:, as: :json
    assert_response :success
    assert_equal "#{@employee_user.name} prototypes", JSON.parse(response.body)['message']
  end

  test 'Owner should get show' do
    headers = @owner_token_header.merge(@prototype_header).merge(@shop_header)
    get v1_prototype_url, headers:, as: :json
    assert_response :success
    assert_equal @prototype.name, JSON.parse(response.body)['name']
  end

  test 'Emlpoyee should get show' do
    headers = @employee_token_header.merge(@prototype_header).merge(@shop_header)
    get v1_prototype_url, headers:, as: :json
    assert_response :success
    assert_equal @prototype.name, JSON.parse(response.body)['name']
  end

  test 'Owner should get create' do
    headers = @owner_token_header.merge(@shop_header)
    post v1_prototypes_create_url, params: { prototype: { name: 'Prototype', group_id: @group.id } }, headers:,
                                   as: :json
    assert_response :created
    assert_equal 'Prototype created successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not get create' do
    headers = @employee_token_header.merge(@shop_header)
    post v1_prototypes_create_url, params: { prototype: { name: 'Prototype', group_id: @group.id } }, headers:,
                                   as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should put update' do
    headers = @owner_token_header.merge(@prototype_header).merge(@shop_header)
    put v1_prototypes_update_url, params: { prototype: { name: 'YourPrototype' } }, headers:, as: :json
    assert_response :success
    assert_equal 'YourPrototype', JSON.parse(response.body)['prototype']['name']
  end

  test 'Employee should not put update' do
    headers = @employee_token_header.merge(@prototype_header).merge(@shop_header)
    put v1_prototypes_update_url, params: { prototype: { name: 'YourPrototype' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
