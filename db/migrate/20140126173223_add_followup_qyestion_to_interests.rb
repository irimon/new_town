class AddFollowupQyestionToInterests < ActiveRecord::Migration
  def change
  	 add_column :interests, :follow_up_question, :text
  end
end
