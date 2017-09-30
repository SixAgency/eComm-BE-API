Spree::ActiveShippingConfiguration.class_eval do

  preference :request_insurance_to_be_included, :boolean, default: false
  preference :boxes, :list, default: "[]"
end
