class V1::PrototypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prototype, only: %i[show update]
  load_and_authorize_resource class: 'Prototype'


  def index
    render json: { message: "#{current_user.name} prototypes", body: Prototype.all }, status: :ok
  end

  def show
    render json: @prototype, status: :ok
  end

  def create
    prototype = Prototype.new(prototype_params)
    if prototype.save
      render json: { message: 'Prototype created successfully', prototype: prototype.id }, status: :created
    else
      render json: { message: 'Prototype not created', errors: prototype.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    @prototype.update(prototype_params)
    if @prototype.save
      render json: { message: 'Prototype updated successfully', prototype: @prototype }, status: :ok
    else
      render json: { message: 'Prototype not updated', errors: @prototype.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # def destroy
  #   @prototype.destroy
  #   if @prototype.destroyed?
  #     render json: { message: 'Prototype removed successfully' }, status: :ok
  #   else
  #     render json: { message: 'Prototype not removed', errors: @prototype.errors.full_messages },
  #            status: :unprocessable_entity
  #   end
  # end

  private

  def set_prototype
    @prototype = Prototype.find(request.headers['PrototypeId'])
    return unless @prototype.nil?

    render json: { message: 'Prototype not found' }, status: :not_found
  end

  def prototype_params
    params.require(:prototype).permit(:name, :group_id)
  end
end
