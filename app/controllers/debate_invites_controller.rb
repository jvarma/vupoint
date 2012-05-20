class DebateInvitesController < ApplicationController

  	before_filter :signed_in_user
  	before_filter :not_to_self, only: :create
  	before_filter :force_mobile


	def create
		
		if @debate_invite.save
			# find if a user by the email id exists
			receiver = User.find_by_email(@debate_invite.email.strip)

			if !receiver.nil?
				# if one exists, notify the receiver
				@debate_invite.update_attributes(receiver_id: receiver.id)

				#send a notification to the receiver user
				# -- the code goes here
				
				#@message = "#{current_user.name.downcase} has invited you to join the debate: #{@debate.content}" 
				#notification = Notification.new(user_id: receiver.id, message: @message)
				
				notification = {
					classname: @debate_invite.class.name,
					unknown_object_id: @debate_invite.id
				}
				
				receiver.notify(notification)
			end

			# in any case, send an email with the debate details
			UserMailer.invitation_for_debate(@debate_invite).deliver
			flash[:success] = "An invitation has been sent to #{@debate_invite.email}"
			
			
		else
			# the invite could not be saved
			#flash[:error] = "You have already invited #{@debate_invite.email} to this debate!"
			error_message = ""
			@debate_invite.errors.full_messages.each do |msg|
				error_message += msg
			end
			flash[:error] = "#{error_message}"
			
		end
		

		redirect_to debate_path(@debate)
	end

  	def destroy
  	end

  	private

  		def not_to_self
  			@debate = Debate.find(params[:debate_invite][:debate_id])
			@debate_invite = @debate.debate_invites.build(params[:debate_invite])

			if (@debate.user.email == @debate_invite.email.downcase)
			
				flash[:error] = "You may not invite yourself!"

				redirect_to debate_path(@debate)

			end
		end

end
