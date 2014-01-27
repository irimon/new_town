class AddAnswerToUserInterests < ActiveRecord::Migration
  def change
  	add_column :user_interests, :follow_up_answer, :string
  end
end
