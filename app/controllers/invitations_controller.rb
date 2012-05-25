class InvitationsController < ApplicationController
	before_filter :signed_in_user
	before_filter :force_mobile
	before_filter :not_to_self_or_registered, only: :create
  MAX_PENDING = 10

  	
  	def new
      pending = Invitation.where('user_id = ?', current_user.id)
      if pending.size >= MAX_PENDING && !current_user.admin
        flash[:error] = "Your previous invitations are still pending! Please wait for some of them getting accepted before sending new invitations."
        redirect_to root_path
      else
        @title = "invite to VUpnt"
        @invitation = Invitation.new      
      end
  		
  	end

  	def create
     
  		if @invitation.save
  			UserMailer.invitation_to_vupnt(@invitation).deliver
        flash[:success] = "Thanks!! An invitation to join VUpnt has been sent to #{@invitation.email}"
  			redirect_to root_path
  		else
  			error_message = ""
        @invitation.errors.full_messages.each do |msg|
				  error_message += msg
        end
        flash[:error] = "#{error_message}"
  			render :new
  		end
  	
  	end

  	def destroy
  		invitation = Invitation.find(params[:id])
  		invitation.destroy
  		flash[:notice] = "Your invitation has been deleted!"
  	end

  	private

  		def not_to_self_or_registered
		  	@invitation = current_user.invitations.build(params[:invitation])
		  	if @invitation.email == current_user.email
		  		@invitation.email = ""
		  		flash.now[:error] = "To invite, please enter the email id of someone other than yourself."
		  		render :new
		  	else
		  		user = User.where('email = ?', @invitation.email)
		  		if user.any?
		  			flash.now[:error] = "A user with email id #{@invitation.email} has alredy signed up!" 
		  			@invitation.email = ""
		  			render :new
		  		end
		  			
		  	end
  		end

  		
end
