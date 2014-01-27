class UsersController < ApplicationController
  
  def update

  	if current_user.current_state == "base"
  		session[:user_params] ||= {}
  	end

  	session[:user_params].deep_merge!(params[:user]) if params[:user]
  	
  	@user = current_user
  	if current_user.current_state == "get_interests" 
   		if (params[:interests])
  			puts params[:interests][:follow_up_question]
  	   		 params[:interests][:id].each do |int|
  	   		 	  if params[:interests][:follow_up_question].include?(int) 
  		  			  @user.add_interest(int,'yes')
  		  		   else
					   @user.add_interest(int,'no')
  		  		   end
  		    	#puts params[:interests][:id]  	
  			end	
  		end
  			
  	else
  		@user.update(session[:user_params])
  	end

  	if params[:next_step]
  		if @user.current_state == "end"
  		else 
  			@user.next!
  		end
  	end
  	if params[:prev_step]
  		@user.prev!
  	end

  	if params[:Update]
  		if @user.update(session[:user_params])
  			puts "Success"
  			flash[:notice] = "User updates saved!"
  			@user.next!
  			redirect_to @user
  		else
  			puts "failure"
  		end

  	end
  end


  def show
  	@user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :relationship, :age, :sex, :interests_attributes => [:id, :name, :_destroy])
  end


  def suggestions
  	current_user.user_interests.each do |int|
  		if int.follow_up_answer == 'yes'
  			@interest = Interest.find_by_id(int.interest_id).name
  			@users = Interest.find_by_id(int.interest_id).users # FIXME - only show willing users
  		end
  	end

  end


end
