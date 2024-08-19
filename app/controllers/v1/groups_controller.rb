class V1::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[show update]
  load_and_authorize_resource class: 'Group'

  def index
    render json: { message: "#{current_user.name} groups", body: Group.all }, status: :ok
  end

  def show
    render json: { body: @group }, status: :ok
  end

  def create
    group = Group.new(group_params)
    if group.save
      render json: { message: 'Group created successfully', group: group.id }, status: :created
    else
      render json: { message: 'Group not created', errors: group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return unless @group.present?

    @group.update(group_params)
    if @group.save
      render json: { message: 'Group updated successfully', group: @group.id }, status: :ok
    else
      render json: { message: 'Group not updated', errors: @group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(request.headers['GroupId'])
    return unless @group.nil?

    render json: { message: 'Group not found' }, status: :not_found
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
