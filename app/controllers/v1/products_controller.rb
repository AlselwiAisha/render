class V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show update destroy]
  load_and_authorize_resource class: 'Product'

  def index
    shop = Shop.find(request.headers['ShopId'])
    if shop.nil? || shop.products.empty?
      render json: { message: 'No products found' }, status: :not_found
    else
      render json: { message: "#{shop.name} products", body: shop.products }, status: :ok
    end
  end

  def show
    render json: @product, status: :ok
  end

  def create
    product = Product.create(product_params)
    if product.save
      render json: { message: 'Product created successfully', product: }, status: :created
    else
      render json: { message: 'Product not created', errors: product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    @product.update(product_params)
    if @product.save
      render json: { message: 'Product updated successfully', product: @product }, status: :ok
    else
      render json: { message: 'Product not updated', errors: @product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    if @product.destroyed?
      @product.prototype.check_to_delete
      render json: { message: 'Product removed successfully' }, status: :ok
    else
      render json: { message: 'Product not removed', errors: @product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(request.headers['ProductId'])
    return unless @product.nil?

    render json: { message: 'Product not found' }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:name, :price, :prototype_id, :shop_id)
  end
end
