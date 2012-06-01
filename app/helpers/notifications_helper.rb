module NotificationsHelper
	def get_notification_content_partial_name(notification)
		"notifications/#{notification.classname.downcase}_content"
	end

	def get_notification_actions_partial_name(notification)
		"notifications/#{notification.classname.downcase}_actions"
	end

	def get_user_from_join_request_notification(notification)
		join_request = JoinRequest.find(notification.unknown_object_id)
		join_request.user
	end

	def get_debate_from_join_request_notification(notification)
		join_request = JoinRequest.find(notification.unknown_object_id)
		join_request.debate
	end
	
end
