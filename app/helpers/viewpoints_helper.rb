module ViewpointsHelper

	def get_viewpoint_from_new_viewpoint_notification(notification)
		Viewpoint.find_by_id(notification.unknown_object_id)
	end

end
