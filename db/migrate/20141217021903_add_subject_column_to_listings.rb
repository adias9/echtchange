class AddSubjectColumnToListings < ActiveRecord::Migration
  def change
    add_column :listings, :subject, :string
  end
end
