module Spree
  Product.class_eval do
    delegate_belongs_to :master, :gift_card
  end
end