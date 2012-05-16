module NotificationsHelper
	def get_notification_content_partial_name(notification)
		#"#{notification.classname.downcase}_content"
		"get_notification_content_partial_name"
	end

	def get_notification_actions_partial_name(notification)
		#"#{notification.classname.downcase}_actions"
		"get_notification_actions_partial_name"
	end
end
