# frozen_string_literal: true

# Version 1 of the API.
module V1
  # This is the controller for the shops.
  class ShopsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_shop, only: %i[update destroy show]
    load_and_authorize_resource class: 'Shop'

    def index
      render json: { message: "#{current_user.name} shops", body: current_user.shops }, status: :ok
    end

    def show
      return unless @shop.present?

      render json: { shop: @shop, employees: @shop.users,
                             shop_employees: @shop.shop_employees, products: @shop.products, works: @shop.works } ,
             status: :ok
    end

    def create
      shop = Shop.create(shop_params)
      if shop.save
        ShopEmployee.create(shop:, user: current_user, role: 'owner')
        render json: { message: 'Shop created successfully', shop: shop.id }, status: :created
      else
        render json: { message: 'Shop not created', errors: shop.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      return unless @shop.present?

      @shop.update(shop_params)
      if @shop.save
        render json: { message: 'Shop updated successfully', shop: @shop }, status: :ok
      else
        render json: { message: 'Shop not updated', errors: @shop.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      return unless @shop.present?

      @shop.destroy
      if @shop.destroyed?
        render json: { message: 'Shop removed successfully' }, status: :ok
      else
        render json: { message: 'Shop not removed', errors: @shop.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_shop
      @shop = Shop.find(request.headers['ShopId'])
      return @shop unless @shop.nil?

      render json: { message: 'Shop not found' }, status: :not_found
    end

    def shop_params
      params.require(:shop).permit(:name, :location, :phone, :website)
    end
  end
end
