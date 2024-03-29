class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers, :join_private_conversation]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy, :send_invitation]
  before_filter :force_mobile


  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    @section_title = "listing people..."
  end

  def new
  	@title = "Please send me a #vupnt invitation!"
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id], include: :debates)
    @debates = @user.debates(include: :viewpoints).paginate(page: params[:page], per_page: 10)
  	@title = @user.name.downcase
  end

  def create
    # This below section is to be removed once vupnt is no more by invitation only
    # check if the email has been sent any invitations
    invitations = Invitation.where('email = ?', params[:user][:email])

    if invitations.nil?
      flash[:notice] = "There are no invitations pending for #{params[:user][:email]}"
      render :new
    else
    # This above section is to be removed once vupnt is no more by invitation only
    
      @user = User.new(params[:user])

      if @user.save
        # Destroy all invitations to join vupnt sent to this user
      
        invitations = Invitation.where('email = ?',@user.email)
        invitations.each do |invitation|
          invitation.destroy
        end
      
        # do not need to seek confirmation of email during invitation
        #@feed_items = User.new.feed(true)
        #UserMailer.confirm_email(@user, @feed_items).deliver
        #flash[:success] = "Hello #{@user.name}! To complete your sign up, please confirm your email id. We have sent you an email with instructions!"
        #redirect_to root_path
        #redirect_to :confirm, {user: @user, confirmation_token: @user.confirmation_token}
        redirect_to action: :confirm, user: @user, confirmation_token: @user.confirmation_token
        
      else
        render :new
      end
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
      flash[:error] = "Your email id could not be confirmed."
    else
      if @user.confirmed_at
        sign_in @user
        flash[:notice] = "You have already confirmed your email id!"
      else
        @user.update_attributes(confirmed_at: Time.now)
        #@user.save!
        update_debate_invites @user
        sign_in @user
        flash[:success] = "Thank you for signing up on vupnt! Start a debate, or share your vupnts on others' debates!" 
      end
    end
    redirect_to root_path
  end

  def invited
    # Invitation is meaningless if the user is already signed in
    if signed_in?
      flash[:notice] = "you are already signed in!"
      redirect_to root_path 
      return
    end

    # Get the invitation object from the clicked URL
    @invitation = Invitation.find_by_confirmation_token(params[:confirmation_token])

    if !@invitation
      # the invitation does not exist!
      flash[:error] = "The page you are looking for does not exist anymore!"
      redirect_to new_session_path

    else
      # the invitation is alright
      # We do not need to check if the invited user has already signed up
      # This is based on the premise that the sign up (UsersController > create) method deletes 
      # all the invitations
      @user = User.new
      @user.name = @invitation.name
      @user.email = @invitation.email
      render :new
    end

  end

  def send_invitation

    invitation_request = InvitationRequest.find(params[:invitation_request])
    notification = Notification.find(params[:notification])
    name = invitation_request.name
    message = "Your invitation to sign up on vupnt!"
    
    @invitation = current_user.invitations.build({
      name: invitation_request.name,
      email: invitation_request.email,
      message: message 
      })

    if @invitation.save
        UserMailer.invitation_to_vupnt(@invitation).deliver
        notification.destroy
        flash[:success] = "An invitation to join VUpnt has been sent to #{@invitation.email}"
        redirect_to notifications_path
      else
        error_message = ""
        @invitation.errors.full_messages.each do |msg|
          error_message += msg
        end
        flash[:error] = "#{error_message}"
        redirect_to notifications_path
      end
        
  end

  def following
    @title = ">> following"
    @user = User.find(params[:id], include: :followed_users)
    @users = @user.followed_users.paginate(page: params[:page], per_page: 10)
    if @users.size == 0
      flash[:notice] = "#{@user.name.downcase} is not following anyone!"
      redirect_to user_path(@user)
    else
      @section_title = "follows..."
      render 'show_follow'
    end
  end

  def followers
    @title = "<< followers"
    @user = User.find(params[:id], include: :followers)
    @users = @user.followers.paginate(page: params[:page], per_page: 10)
    if @users.size == 0
      flash[:notice] = "#{@user.name.downcase} has no followers!"
      redirect_to user_path(@user)
    else
      @section_title = "...followers"
      render 'show_follow'
    end
  end

  def search_by_name
    name = params[:full_name]
    name_tags = name.split

    @users = User.tagged_with(params[:full_name].split, any: true).paginate(page: params[:page], per_page: 10)
    if @users.size > 0
      #flash.now[:success] = "found #{@users.size} people with name like #{name}!"
      #render :index
      @section_title = "people with name ~ #{name}"
    else
      flash[:error] = "matching results not found for #{params[:full_name]}!"
      redirect_to users_path
    end
  end

  def notifications
    #cookies.permanent[:notifications_last_viewed] =  Time.now
    cookies.permanent[:notifications_last_viewed] =  Time.now
    @user = current_user
    @notifications = @user.notifications.paginate(page: params[:page], per_page: 10)
  end

  def join_private_conversation
    private_debate = Debate.find(params[:id], include: :user)
    debate_owner = private_debate.user
    requestor = current_user
    join_request = private_debate.join_requests.build({user_id: current_user.id})
    if join_request.save
      # notify debate_owner
      notification = {
          classname: join_request.class.name,
          unknown_object_id: join_request.id
        }
      debate_owner.notify(notification)
      flash[:success] = "Your request to join conversation has been sent to #{debate_owner.name.downcase}!"
    else
      flash[:error] = "Your request could not be sent to #{debate_owner.name.downcase}"
    end
    redirect_to root_path
  end



  private
    
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def update_debate_invites(user)
      email = user.email
      debate_invites = DebateInvite.where('email = ?', email)
      debate_invites.each do |debate_invite|
        debate_invite.update_attributes(receiver_id: user.id)
        notification = {
          classname: debate_invite.class.name,
          unknown_object_id: debate_invite.id
        }
        # if its a private debate, then update debate participation as well!
        debate = debate_invite.debate
        debate.participations.create({user_id: user.id})
        user.notify(notification)
      end     
    end


end















