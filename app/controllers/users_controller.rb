class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
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
    @debates = @user.debates.paginate(page: params[:page], per_page: 10)
  	@title = @user.name.downcase
  end

  def create
  	if verify_recaptcha
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        UserMailer.confirm_email(@user).deliver
        flash[:success] = "Hey #{@user.name}! You have signed up successfully but you still need to confirm your email id. We have sent you an email with instructions!"
        redirect_to @user
      else
        render :new
      end
    else
      flash[:error] = "problemo...!"
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

  def confirm
    @user = User.find_by_id(params[:user])
    if (!@user || !(@user.confirmation_token == params[:confirmation_token]))
      flash[:error] = "Oops! Your email id could not be confirmed."
    else
      if @user.confirmed_at
        sign_in @user
        flash[:notice] = "You have already confirmed your email id!"
      else
        @user.confirmed_at = Time.now
        @user.save!
        sign_in @user
        flash[:success] = "Yipee!!! You have successfully confirmed your email id!" 
      end
    end
    redirect_to root_path
  end

  def following
    @title = ">> following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page], per_page: 10)
    if @users.size == 0
      flash[:notice] = "#{@user.name.downcase} is not following anyone!"
      redirect_to user_path(@user)
    else
      render 'show_follow'
    end
  end

  def followers
    @title = "<< followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 10)
    if @users.size == 0
      flash[:notice] = "#{@user.name.downcase} has no followers!"
      redirect_to user_path(@user)
    else
      render 'show_follow'
    end
  end

  def search_by_name
    @users = User.by_name(params[:full_name]).paginate(page: params[:page], per_page: 10)
    if @users.size > 0
      flash.now[:success] = "found #{@users.size} people!"
      render :index
    else
      flash[:error] = "matching results not found for #{params[:full_name]}!"
      redirect_to users_path
    end
  end


  private
    
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


end















