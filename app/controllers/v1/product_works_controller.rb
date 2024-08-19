class V1::ProductWorksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product_work, only: %i[update destroy]
  load_and_authorize_resource class: 'ProductWork'

  def create
    product_work = ProductWork.new(product_work_params)
    if product_work.save
      render json: { message: 'Product work created successfully', product_work: product_work }, status: :created
    else
      render json: { message: 'Product work not created', errors: product_work.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return unless @product_work.present?

    @product_work.update(product_work_params)

    if @product_work.save
      render json: { message: 'percent updated successfully', product_work: @product_work }, status: :ok
    else
      render json: { message: 'Product work not updated', errors: @product_work.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @product_work.destroy
    if @product_work.destroyed?
      render json: { message: 'Product work removed successfully' }, status: :ok
    else
      render json: { message: 'Product work not removed', errors: @product_work.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_product_work
    @product_work = ProductWork.find(request.headers['ProductWorkId'])
    return unless @product_work.nil?

    render json: { message: 'Product work not found', product_work: @product_work }, status: :not_found
  end

  def product_work_params
    params.require(:product_work).permit(:product_id, :work_id, :percent)
  end
end
