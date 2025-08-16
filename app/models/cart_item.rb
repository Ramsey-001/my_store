class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  before_validation :set_default_quantity

  private

  def set_default_quantity
    self.quantity ||= 0
  end
end
