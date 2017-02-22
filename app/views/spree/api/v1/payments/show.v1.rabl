object @payment
attributes *payment_attributes

child :refunds do
    extends "spree/api/v1/refunds/show"
end