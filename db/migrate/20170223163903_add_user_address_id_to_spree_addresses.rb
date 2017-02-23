class AddUserAddressIdToSpreeAddresses < ActiveRecord::Migration[5.0]
  def up
    add_column :spree_addresses, :user_address_id, :integer
    add_index :spree_addresses, [:user_address_id], name: 'index_addresses_on_user_address_id'
  end

  def down
    remove_column :spree_addresses, :user_address_id
  end
end
