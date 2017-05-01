class AddNoteToSpreeOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_orders, :note, :string
  end
end
