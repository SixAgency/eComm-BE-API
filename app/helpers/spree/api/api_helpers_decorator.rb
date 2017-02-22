Spree::Api::ApiHelpers.module_eval do
  Spree::Api::ApiHelpers::ATTRIBUTES << :refund_attributes

  @@refund_attributes = [
      :id,
      :amount,
      :refund_reason_id
  ]
end
