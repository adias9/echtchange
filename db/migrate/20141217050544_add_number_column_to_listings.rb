class AddNumberColumnToListings < ActiveRecord::Migration
  def change
    add_column :listings, :number, :integer
  end
end
