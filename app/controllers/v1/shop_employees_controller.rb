class V1::ShopEmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop_employee, only: %i[update destroy]
  load_and_authorize_resource class: 'ShopEmployee'

  def create
    shop_employee = ShopEmployee.create(shop_employee_params)
    if shop_employee.save
      render json: { message: "Added #{shop_employee.user.name} as an #{shop_employee.role}", shop_employee: shop_employee.id },
             status: :created
    else
      render json: { message: 'There is an error in adding the employee', errors: shop_employee.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    @shop_employee.update(shop_employee_params)
    if @shop_employee.save
      render json: { message: 'employee updated successfully', shop_employee: @shop_employee.id }, status: :ok
    else
      render json: { message: 'Shop employee not updated', errors: @shop_employee.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @shop_employee.destroy
    if @shop_employee.destroyed?
      render json: { message: 'Employee removed successfully' }, status: :ok
    else
      render json: { message: 'Employee not removed', errors: @shop_employee.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_shop_employee
    @shop_employee = ShopEmployee.find(request.headers['ShopEmployeeId'])
    return unless @shop_employee.nil?

    render json: { message: 'Employee not found' }, status: :not_found
  end

  def shop_employee_params
    params.require(:shop_employee).permit(:user_id, :shop_id, :role)
  end
end
