class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.integer :age
      t.string :sex
      t.integer :user_id

      t.timestamps
    end
  end
end
