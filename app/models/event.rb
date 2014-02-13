class Event < ActiveRecord::Base
	has_many :event_interests, dependent: :destroy
	has_many :interests, :through =>  :event_interests

	#def find_by_interest(interest_id)
	#	self.event_interests.find_by_interest_id
	#end
end
