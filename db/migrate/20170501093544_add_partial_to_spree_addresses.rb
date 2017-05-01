class AddPartialToSpreeAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :spree_addresses, :partial, :boolean, default: false
  end
end
