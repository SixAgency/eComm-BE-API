Spree::Api::ApiHelpers.module_eval do
  class_variable_set(:@@refund_attributes, [ :id, :amount, :refund_reason_id])
  mattr_reader :refund_attributes
end
