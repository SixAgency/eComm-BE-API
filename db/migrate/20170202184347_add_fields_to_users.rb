class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :spree_users, :f_name, :string
    add_column :spree_users, :l_name, :string
  end

  def down
    remove_column :spree_users, :f_name
    remove_column :spree_users, :l_name
  end
end
