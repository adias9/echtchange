class AddConditionColumnToListings < ActiveRecord::Migration
  def change
    add_column :listings, :condition, :string
  end
end
