class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = (cart_item.quantity || 0) + params[:quantity].to_i

    if cart_item.save
      redirect_to cart_path(@cart), notice: "#{product.name} added to cart."
    else
      redirect_to products_path, alert: "Could not add product."
    end
  end

  def update
  cart_item = @cart.cart_items.find(params[:id])
  new_quantity = params[:cart_item][:quantity].to_i
  cart_item.update(quantity: new_quantity)
  redirect_to cart_path(@cart)
end


  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path(@cart)
  end

  private

  def set_cart
    @cart = current_user.cart
  end
end
