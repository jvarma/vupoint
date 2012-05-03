class PagesController < ApplicationController
  def home
  	if signed_in?
  		@debate = current_user.debates.build
  		@feed_items = current_user.feed.paginate(page: params[:page], per_page: 10) 
  	end

  end

  def help
  	@title = "help"
  end

  def tou
  	@title = "terms of use"
  end
end
