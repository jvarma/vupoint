class UsersController < ApplicationController
  def new
  	@title = "sign up"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  	@title = @user.name.downcase
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
		  flash[:success] = "You have signed up successfully!"
  		redirect_to @user
  	else
  		render :new
  	end
  end
end
