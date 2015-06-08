class AddCampusAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :campus_building, :string
    add_column :users, :campus_room_number, :integer
  end
end
