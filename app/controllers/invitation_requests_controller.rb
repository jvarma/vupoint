class InvitationRequestsController < ApplicationController
	before_filter :unsigned

  	def new
  		@title = "#vupnt - get invited!"
  		@invitation_request = InvitationRequest.new
  	end

  	def create
  		@invitation_request = InvitationRequest.new(params[:invitation_request])
  		if User.find_by_email(@invitation_request.email)
  			flash.now[:error] = "A user with that email id already exists!"
  			render :new
      else
        if Invitation.find_by_email(@invitation_request.email)
          flash[:notice] = "An invitation has already been sent to the email id. Do remember to check your junk/spam folder!"
          redirect_to root_path
      	else
  		  	if @invitation_request.save
  			   	#notify the admin
  				  notification = {
              classname: @invitation_request.class.name,
              unknown_object_id: @invitation_request.id
				    }
				
				    admin.notify(notification)

  				  flash[:success] = "We will send you an invitation soon! Please add izebrg@gmail.com to your address book to prevent your invitation from landing in your junk or spam folder!"
  				  redirect_to root_path
          else
  				  error_message = ""
        		@invitation_request.errors.full_messages.each do |msg|
					     error_message += msg + " "
        		end
        		flash[:error] = "#{error_message}"
  				  render :new 
          end
  		  end
      end
    end

  	def destroy
  	end

  	private

  		def unsigned
  			if current_user
  				flash[:error] = "You are already signed in!"
  				redirect_to root_path
  			end
  		end

end
