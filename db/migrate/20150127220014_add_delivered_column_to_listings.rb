class AddDeliveredColumnToListings < ActiveRecord::Migration
  def change
    add_column :listings, :delivered, :boolean
  end
end
