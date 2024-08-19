class V1::WorksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work, only: %i[update destroy]
  load_and_authorize_resource class: 'Work'

  def create
    work = Work.new(work_params)
    if work.save
      render json: { message: 'Work created successfully', work: work.id }, status: :created
    else
      render json: { message: 'Work not created', errors: work.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @work.update(work_params)
    if @work.save
      render json: { message: 'Work updated successfully', work: @work.id }, status: :ok
    else
      render json: { message: 'Work not updated', errors: @work.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @work.destroy
    if @work.destroyed?
      render json: { message: 'Work removed successfully' }, status: :ok
    else
      render json: { message: 'Work not removed', errors: @work.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_work
    @work = Work.find(request.headers['WorkId'])
    return unless @work.nil?

    render json: { message: 'Work not found' }, status: :not_found
  end

  def work_params
    params.require(:work).permit(:name, :shop_id)
  end
end
