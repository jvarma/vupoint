module InvitationRequestsHelper

	def get_invitation_request_from_notification(notification)
		InvitationRequest.find_by_id(notification.unknown_object_id)
	end
end
