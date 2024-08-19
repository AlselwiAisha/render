class V1::DetailsOfWorksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_details_of_work, only: %i[update destroy show]
  load_and_authorize_resource class: 'DetailsOfWork'

  def index
    render json: { message: 'Details of work', body: DetailsOfWork.all }, status: :ok
  end

  def show
    render json: { body: @details_of_work }, status: :ok
  end

  def create
    details_of_work = DetailsOfWork.new(details_of_work_params)
    if details_of_work.save
      render json: { message: 'Details of work created successfully', details_of_work: details_of_work.id },
             status: :created
    else
      render json: { message: 'Details of work  not created', errors: details_of_work.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    return unless @details_of_work.present?

    @details_of_work.update(details_of_work_params)
    if @details_of_work.save
      render json: { message: 'Details of work updated successfully', details_of_work: @details_of_work }, status: :ok
    else
      render json: { message: 'Details of work not updated', errors: @details_of_work.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    return unless @details_of_work.present?

    @details_of_work.destroy
    if @details_of_work.destroyed?
      render json: { message: 'Details of work removed successfully' }, status: :ok
    else
      render json: { message: 'Details of work not removed', errors: @details_of_work.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_details_of_work
    @details_of_work = DetailsOfWork.find(request.headers['DetailsId'])
    return unless @details_of_work.nil?

    render json: { message: 'Data not found' }, status: :not_found
  end

  def details_of_work_params
    params.require(:details_of_work).permit(:shop_employee_id, :product_work_id, :count, :percent_done, :start_date)
  end
end
