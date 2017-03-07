Deface::Override.new(:virtual_path => 'spree/admin/products/new',
                     :name => 'add_gift_card_to_product_edit',
                     insert_after: '[data-hook="new_product_shipping_category"]',
                     :partial => 'spree/admin/products/edit_gift_card')
