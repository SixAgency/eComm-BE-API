Deface::Override.new(
    virtual_path: 'spree/admin/orders/_shipment',
    name: 'add_note_to_shipment',
    insert_after: '.show-tracking',
    partial: 'spree/admin/orders/shipment_note',
)
