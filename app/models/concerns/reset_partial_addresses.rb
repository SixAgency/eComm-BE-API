module ResetPartialAddresses
  extend ActiveSupport::Concern
  
  included do
    state_machine do
      before_transition from: :cart, do: :reset_partial_shipment!
    end
    
    def reset_partial_shipment!
      if self.ship_address.present? && self.ship_address.partial
        self.ship_address.destroy
        self.ship_address = nil  
        reset_shipment!

        reload
        create_tax_charge!
        update_totals
        persist_totals
      end
    end

    private
    def reset_shipment!
      all_adjustments.shipping.delete_all

      shipment_ids = shipments.map(&:id)
      Spree::StateChange.where(stateful_type: "Spree::Shipment", stateful_id: shipment_ids).delete_all
      Spree::ShippingRate.where(shipment_id: shipment_ids).delete_all

      shipments.delete_all
      inventory_units.on_hand_or_backordered.delete_all 
    end
  end
end
