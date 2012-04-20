module ApplicationHelper
	def full_title(page_title)
		if page_title.nil?
			"my view point"
		else
			"my view point | " + page_title
		end
	end

end
