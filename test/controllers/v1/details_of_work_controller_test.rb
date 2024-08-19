require 'test_helper'

class V1::DetailsOfWorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    # objects
    @owner_user = users(:one)
    @employee_user = users(:two)
    @shop_employee = shop_employees(:user1_shop1_owner)
    @product_work = product_works(:two)
    @details_of_work = details_of_works(:one)
    @details_of_work2 = details_of_works(:two)
    @shop = shops(:one)

    # jwt payload
    owner_jwt_payload = { sub: @owner_user.id, jti: @owner_user.jti }
    employee_jwt_payload = { sub: @employee_user.id, jti: @employee_user.jti }

    # jwt token
    @owner_token = JWT.encode(owner_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
    @employee_token = JWT.encode(employee_jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)

    # headers
    @owner_header = { 'Authorization': "Bearer #{@owner_token}" }
    @employee_header = { 'Authorization': "Bearer #{@employee_token}" }
    @details_id = { 'DetailsId': @details_of_work.id.to_s }
    @details_id2 = { 'DetailsId': @details_of_work2.id.to_s }
    @shop_id = { 'ShopId': @shop.id }
  end

  test 'Owner_should get index' do
    headers = @owner_header.merge(@shop_id)
    get v1_works_details_url, headers:, as: :json
    assert_response :success
    assert_equal 'Details of work', JSON.parse(response.body)['message']
  end

  test 'Employee should get index' do
    headers = @employee_header.merge(@shop_id)
    get v1_works_details_url, headers:, as: :json
    assert_response :success
    assert_equal 'Details of work', JSON.parse(response.body)['message']
  end

  test 'Owner should get show' do
    headers = @owner_header.merge(@details_id).merge(@shop_id)
    get v1_works_detail_url, headers:, as: :json
    assert_response :success
  end

  test 'Employee should get show' do
    headers = @employee_header.merge(@details_id).merge(@shop_id)
    get v1_works_detail_url, headers:, as: :json
    assert_response :success
  end

  test 'Owner should post create' do
    headers = @owner_header.merge(@shop_id)
    post v1_works_details_create_url,
         params: { details_of_work: { shop_employee_id: @shop_employee.id, product_work_id: @product_work.id, count: 1, percent_done: '0.5', start_date: '2021-09-01' } }, headers:, as: :json
    assert_response :success
    assert_equal 'Details of work created successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not post create' do
    headers = @employee_header.merge(@shop_id)
    post v1_works_details_create_url,
         params: { details_of_work: { shop_employee_id: @shop_employee.id, product_work_id: @product_work.id, count: 1, percent_done: '0.5', start_date: '2021-09-01' } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should put update' do
    headers = @owner_header.merge(@details_id).merge(@shop_id)
    put v1_works_details_update_url, params: { details_of_work: { count: 2 } }, headers:, as: :json
    assert_response :success
    assert_equal 'Details of work updated successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not put update' do
    headers = @employee_header.merge(@details_id).merge(@shop_id)
    put v1_works_details_update_url, params: { details_of_work: { count: 2 } }, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end

  test 'Owner should get destroy' do
    headers = @owner_header.merge(@details_id2).merge(@shop_id)
    delete v1_works_details_delete_url, headers:, as: :json
    assert_response :success
    assert_equal 'Details of work removed successfully', JSON.parse(response.body)['message']
  end

  test 'Employee should not get destroy' do
    headers = @employee_header.merge(@details_id2).merge(@shop_id)
    delete v1_works_details_delete_url, headers:, as: :json
    assert_response :forbidden
    assert_equal 'Access denied', JSON.parse(response.body)['error']
  end
end
