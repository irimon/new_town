class AddNameToKids < ActiveRecord::Migration
  def change
  	  add_column :kids, :name, :string
  end
end
