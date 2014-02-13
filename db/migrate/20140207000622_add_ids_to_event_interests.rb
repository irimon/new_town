class AddIdsToEventInterests < ActiveRecord::Migration
  def change
  	add_column :event_interests, :event_id, :integer
  	add_column :event_interests, :interest_id, :integer
  end
end
