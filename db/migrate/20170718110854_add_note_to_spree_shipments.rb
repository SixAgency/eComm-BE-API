class AddNoteToSpreeShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_shipments, :note, :string
  end
end
