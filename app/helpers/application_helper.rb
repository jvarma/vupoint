module ApplicationHelper
	def full_title(page_title)
		if page_title.nil?
			"my view point"
		else
			page_title
		end
	end

	def bookmark
		title = @title? "'#{@title}'" : "vupnt"
		url = "'http://www.mysite.com#{request.url}'"
		%Q|<a href="javascript:bookmarksite(#{title}, #{url});">Bookmark this page</a>|
	end  


end
