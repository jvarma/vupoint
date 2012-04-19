class PagesController < ApplicationController
  def home
  end

  def help
  	@title = "help"
  end

  def tou
  	@title = "terms of use"
  end
end
