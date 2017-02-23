Spree::Api::ApiHelpers.module_eval do
  mattr_reader :refund_attributes

  class_variable_set(:@@refund_attributes, [ :id, :amount, :refund_reason_id])
end
