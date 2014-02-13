class Interest < ActiveRecord::Base
	has_many :user_interests, dependent: :destroy
	has_many :users, :through =>  :user_interests
	has_many :event_interests, dependent: :destroy
	has_many :events, :through =>  :event_interests
end
