require 'test_helper'

class V1::WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Objects
    @work = works(:one)
    @work2 = works(:two)
    @owner_user = users(:one)
    @employee_user = users(:two)
    @shop = shops(:one)

    # jwt payload
    owner_jwt_payload = { sub:@owner_user.id, jti: @owner_user.jti }
    employee_jwt_payload = { sub: @employee_user.id, jti: @employee_user.jti }

    # jwt token
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    
    # headers
    @owner_token_header={ 'Authorization': "Bearer #{@owner_token}" }
    @employee_token_header={ 'Authorization': "Bearer #{@employee_token}" }
    @work_id = { 'WorkId': "#{@work.id}" }
    @work2_id = { 'WorkId': "#{@work2.id}" }
    @shop_id = { 'ShopId': "#{@shop.id}" }
  end

  test 'owner should post create a work' do
    headers = @owner_token_header.merge( @shop_id)
    post v1_works_create_url, params: { work: { name: 'Samething', shop_id: @shop.id } }, headers:, as: :json
    assert_response :success
    assert_equal 'Work created successfully', JSON.parse(response.body)['message']
  end

  test 'employee should post create a work' do
    headers = @employee_token_header.merge( @shop_id)
    post v1_works_create_url, params: { work: { name: 'Samething', shop_id: @shop.id } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'owner should put update a work' do
    headers = @owner_token_header.merge( @work_id).merge( @shop_id)
    put v1_works_update_url, params: { work: { name: 'Samething' } }, headers:, as: :json
    assert_response :success
    assert_equal 'Work updated successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should put update a work' do
    headers = @employee_token_header.merge( @work_id).merge( @shop_id)
    put v1_works_update_url, params: { work: { name: 'Samething' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'owner should delete a work' do
    headers = @owner_token_header.merge( @work2_id).merge( @shop_id)
    delete v1_works_delete_url, headers:, as: :json
    assert_response :success
    assert_equal 'Work removed successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not delete a work' do
    headers = @employee_token_header.merge( @work2_id).merge( @shop_id)
    delete v1_works_delete_url, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
