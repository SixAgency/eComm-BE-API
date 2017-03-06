class CreateSquareCustomer < ActiveRecord::Migration[5.0]
  def change
    create_table :square_customers do |t|
      t.references :owner, polymorphic: true, index: false
      t.string :square_id
      t.timestamps
    end

    add_index :square_customers, [:owner_type, :owner_id], unique: true
  end
end
