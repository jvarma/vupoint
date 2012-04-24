class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    #@title = "#{@users.count} users"
  end

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

  def edit
    @title = @user.name.downcase
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated successfully!"
      sign_in @user
      redirect_to @user
    else
      render :edit
    end

  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end


  private
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in first!"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


end















