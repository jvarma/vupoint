class NotificationsController < ApplicationController
	before_filter :signed_in_user

	before_filter :correct_user

	def destroy
    	@notification.destroy
    	flash[:success] = "Notification deleted!"
    	if current_user.notifications.any?
    		redirect_to notifications_path(current_user)
    	else
    		redirect_to root_path
    	end

  	end


  	private

    	def correct_user
      		@notification = Notification.find(params[:id])
      		unless current_user?(@notification.user)
	      		redirect_to root_path
	      	end
    	end

end
