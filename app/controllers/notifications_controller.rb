class NotificationsController < ApplicationController
	def destroy
    	Notification.find(params[:id]).destroy
    	flash[:success] = "Notification deleted!"
    	if current_user.notifications.any?
    		redirect_to notifications_path(current_user)
    	else
    		redirect_to root_path
    	end

  	end

end
