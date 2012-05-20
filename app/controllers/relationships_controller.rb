class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  before_filter :force_mobile


  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.mobile { redirect_to @user}
      format.js
    end
    
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.mobile {redirect_to @user}
      format.js
    end
    
  end
end