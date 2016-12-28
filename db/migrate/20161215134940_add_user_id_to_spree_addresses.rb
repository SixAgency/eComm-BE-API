class AddUserIdToSpreeAddresses < ActiveRecord::Migration[5.0]
  def up
    add_column :spree_addresses, :user_id, :integer
    add_index :spree_addresses, :user_id
  end

  def down
    remove_column :spree_addresses, :user_id
  end
end
