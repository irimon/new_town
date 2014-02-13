class CreateEventInterests < ActiveRecord::Migration
  def change
    create_table :event_interests do |t|

      t.timestamps
    end
  end
end
