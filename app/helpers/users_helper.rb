module UsersHelper

	def get_user_from_notification(notification)
		User.find_by_id(notification.unknown_object_id)
	end
end
