class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 #attr_accessible :age, :email, :interests, :kids, :name, :relationship, :sex

 include Workflow
  workflow do
    state :base do
      event :next, :transitions_to => :relationship
    end
     state :relationship do
      event :next, :transitions_to => :get_interests
      event :prev, :transitions_to => :base
    end
    state :get_interests do
      event :next, :transitions_to => :end
      event :prev, :transitions_to => :relationship
    end

    state :end do
    	  event :prev, :transitions_to => :get_interests
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
end
