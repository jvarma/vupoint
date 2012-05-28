module InvitationRequestsHelper

	def get_invitation_request_from_notification(notification)
		InvitationRequest.find_by_id(notification.unknown_object_id)
	end

	def get_admin
    	User.find_by_admin(true)
  	end
end
