class Interest < ActiveRecord::Base
	has_many :user_interests, dependent: :destroy
	has_many :users, :through =>  :user_interests
end
