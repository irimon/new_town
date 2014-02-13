class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 #attr_accessible :age, :email, :interests, :kids, :name, :relationship, :sex
  has_many :user_interests, dependent: :destroy
  has_many :interests, :through =>  :user_interests

  has_many :kids, dependent: :destroy

  accepts_nested_attributes_for :interests, allow_destroy: true
  accepts_nested_attributes_for :kids, allow_destroy: true

 include Workflow
  workflow do
    state :base do
      event :next, :transitions_to => :relationship
      event :prev, :transitions_to => :base
    end
     state :relationship do
      event :next, :transitions_to => :get_interests
      event :prev, :transitions_to => :base
    end
   
    state :get_interests do
      event :next, :transitions_to => :kids
      event :prev, :transitions_to => :relationship
    end
   
    state :kids do
      event :next, :transitions_to => :end
      event :prev, :transitions_to => :get_interests
    end

    state :end do
    	  event :prev, :transitions_to => :kids
    	  event :next, :transitions_to => :base
    end
    #state :being_reviewed do
    #  event :accept, :transitions_to => :accepted
    #  event :reject, :transitions_to => :rejected
    #end
    #state :accepted
    #state :rejected
  end    

  def set_default_state 
  	current_state = base
  end

  def add_interest(interest_id, answer)
  	if interest_id.to_i > 0
  		if !user_interests.find_by_interest_id(interest_id)
  			user_interests.create!(interest_id: interest_id, follow_up_answer: answer)
  		end
  	end
  end

  def add_kid(params)
  	 kids.create!(sex: params[:sex], age: params[:age], name: params[:name])
  end
end
