class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_user.cart
    if @cart.cart_items.empty?
      redirect_to products_path, alert: "Your cart is empty."
    end
  end

  def create
    cart = current_user.cart

    if cart.cart_items.empty?
      redirect_to products_path, alert: "Your cart is empty."
      return
    end

    order = current_user.orders.create(
      total: cart.total_price,
      status: "pending"
    )

    cart.cart_items.each do |item|
      # Prevent checkout if product stock is not enough
      if item.quantity > item.product.stock
        redirect_to cart_path, alert: "#{item.product.name} is out of stock."
        return
      end

      # Reduce the product stock
      item.product.update(stock: item.product.stock - item.quantity)

      # Create the order item
      order.order_items.create(
        product: item.product,
        quantity: item.quantity,
        price: item.product.price
      )
    end

    # Clear the cart
    cart.cart_items.destroy_all

    redirect_to order_path(order), notice: "Order placed successfully!"
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
