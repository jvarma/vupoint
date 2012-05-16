module NotificationsHelper
	def get_notification_content_partial_name(notification)
		"#{notification.classname.downcase}_content"
	end

	def get_notification_actions_partial_name(notification)
		"#{notification.classname.downcase}_actions"
	end
end
