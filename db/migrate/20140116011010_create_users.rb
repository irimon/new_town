class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.string :sex
      t.text :interests
      t.string :relationship
      t.text :kids

      t.timestamps
    end
  end
end
