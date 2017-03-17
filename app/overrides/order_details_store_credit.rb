Deface::Override.new(
    virtual_path: 'spree/shared/_order_details',
    name: 'order_details_store_credit',
    insert_after: '[data-hook="order_details_adjustments"]',
    partial: 'spree/shared/order_details_store_credit'
)

Deface::Override.new(
    virtual_path: 'spree/shared/_order_details',
    name: 'order_details_store_credit_change_total',
    replace_contents: '[data-hook="order_details_total"] .total',
    partial: 'spree/shared/order_details_total_charge'
)