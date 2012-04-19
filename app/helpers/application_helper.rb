module ApplicationHelper
	def full_title(page_title)
		if page_title.nil?
			"vupoint"
		else
			"vupoint | " + page_title
		end
	end

end
