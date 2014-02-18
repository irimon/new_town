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

  	   		 	  if !params[:interests][:follow_up_question].nil? and params[:interests][:follow_up_question].include?(int) 
  		  			  @user.add_interest(int,'yes')
  		  		   else
					   @user.add_interest(int,'no')
  		  		   end
  		    	#puts params[:interests][:id]  j	
  			end	
  		end
  	
  	else		
  	    if current_user.current_state == "kids"
  	 #    	puts params
  		 	if (params[:kid] and params[:kid][:age]!='')
  		 		@user.add_kid(params[:kid])
  		 	end
  		 end
  		# 		@user.update(session[:user_params])
  		# 	end
  		# end
  		@user.update(session[:user_params])
  	end

  	if params[:next_step]
  		#if @user.current_state == "end"
  		#else 
  			@user.next!
  		#end
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
  	if params[:select_id] 
  		@user = User.find_by_id(params[:select_id])
  	else
  		@user = current_user
  	end
  end

  def user_params
    params.require(:user).permit(:name, :relationship, :age, :sex, :interests_attributes => [:id, :name, :_destroy])
  end


  def suggestions

  	current_user.user_interests.each do |int|
  		if int.follow_up_answer == 'yes'
  			@interest = Interest.find_by_id(int.interest_id).name
  			@users = Interest.find_by_id(int.interest_id).users # FIXME - only show willing users
  			#@events = Event.find_each do |event| 
  			#		     Event.find_by_id()
			#		  end
			ids = []
			
			#EventInterest.f(int.interest_id).event_id
			
			EventInterest.where(interest_id: int.interest_id).find_each do |ev_id| 
				ids << ev_id
			end
			@events = Event.find(ids)
  			#@events = Event.find(:all, :conditions => ["event_interests.interest_id = ?", int.interest_id])
  		end
  	end

  
	current_user.kids.each do |kid|
		@other_kids_str = ""
		#@tmpkids = Kid.find_all_by_age_and_sex(kid.age,kid.sex)
		#@tmp = @tmpkids.map{|k| k.to_json(:only => [:age, :sex]) }
		@tmp = Kid.where(age: kid.age,sex: kid.sex).to_json(only: [:age, :sex])
		#@tmp = Kid.find_all_by_age_and_sex(kid.age,kid.sex).to_json(only: [:age, :sex])
		#JSON.parse(@tmp.replace(/&quot;/g,'"'))
		#@tmp = @tmp_j.gsub("&quot","\"\'")
		#remap = @tmpkids.map {|k, v| { Age: k, Sex: v} }  
		
		 #tmpkids = Kid.find_all_by_age_and_sex(kid.age,kid.sex) 
      	#for other_kid in  tmpkids
      	#	 if (other_kid.id != kid.id and other_kid.name != nil) 
		#		@other_kids_str = @other_kids_str + "#{other_kid.name}," + "#{other_kid.age}," + "#{other_kid.sex},"  + "/n"
      	#	end
      	#end
    end
#		instance_variable_set("@kids_" + kid.id, Kid.find_by_age_and_sex(kid.age,kid.sex))
  		#@kids_"#{kid.id}" = Kid.find_by_age_and_sex(kid.age,kid.sex)		
 # 	end
 #uri = URI('https://api.meetup.com/2/open_events.xml?&sign=true&text=football&zip=02142&page=20&key='+MEETUP_CONFIG['key'])
  
  current_user.user_interests.each do |int|
    @interest = Interest.find_by_id(int.interest_id)
    uri_str = "https://api.meetup.com/2/open_events.xml?&sign=true&topic=#{@interest.name}&zip=02142&page=20&key="+MEETUP_CONFIG['key']
    uri = URI(uri_str)
	  req = Net::HTTP.get(uri)
	  doc = Nokogiri::XML(req)
    instance_variable_set("@meetup_names_#{@interest.id}", doc.xpath('//item/name/text()') )
  	instance_variable_set("@meetup_urls_#{@interest.id}", doc.xpath('//item/event_url/text()') )
    #@meetup_names_ = doc.xpath('//item/name/text()')
    #@meetup_urls = doc.xpath('//item/event_url/text()')
  end
  #debugger
 end


end
