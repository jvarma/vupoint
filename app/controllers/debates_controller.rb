class DebatesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def create
  	@debate = current_user.debates.build(params[:debate])
    if @debate.save
      	flash[:success] = "A new topic created!"
      	redirect_to root_path
    else
    	@feed_items = []
      	render 'pages/home'
    end
  end

  def destroy
	@debate.destroy
    redirect_back_or root_path
  end

   private

    def correct_user
      @debate = current_user.debates.find_by_id(params[:id])
      redirect_to root_path if @debate.nil?
    end
end