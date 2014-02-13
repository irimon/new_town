class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :event_time
      t.text :description
      t.text :url

      t.timestamps
    end
  end
end
