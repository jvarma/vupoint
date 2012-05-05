class PagesController < ApplicationController
  require 'will_paginate/array'
  def home
  	if signed_in?
  		@debate = current_user.debates.build
  		@feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    else
      @feed_items = Debate.recent_debates(5).paginate(page: params[:page], per_page: 5)
    end

  end

  def help
  	@title = "help"
  end

  def tou
  	@title = "terms of use"
  end
end
