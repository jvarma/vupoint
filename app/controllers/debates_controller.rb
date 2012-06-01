class DebatesController < ApplicationController
  before_filter :signed_in_user, except: :show
  before_filter :correct_user, only: :destroy
  before_filter :force_mobile


  def create
  	@debate = current_user.debates.build(params[:debate])
    if @debate.save
        if @debate.is_private
      	flash[:success] = "A private conversation has started! Invite your friends to join."
      else
        flash[:success] = "A public conversation has started! Invite your friends to join."
      end
        @participation = @debate.participations.build({user_id: current_user.id})
        @participation.save    
      	redirect_to debate_path @debate
    else
    	@feed_items = []
      	render 'pages/home'
    end
  end

  def destroy
  @debate.destroy
    redirect_back_or root_path
  end

  def show
    @debate = Debate.find(params[:id])
    @title = "#vupnt " + @debate.content 
    @user = @debate.user
    @viewpoint = @debate.viewpoints.build
    if current_user?(@user)
      @viewpoints = @debate.viewpoints.paginate(page: params[:page], per_page: 10)
    else
      @viewpoints = @debate.viewpoints.published.paginate(page: params[:page], per_page: 10)
    end

    
    # check if there are any invitations from the debate owner to 
    # the current user for THIS debate.

    if signed_in?
      user_invites = DebateInvite.where(
        'debate_id = ? AND sender_id = ? AND receiver_id = ?', 
        @debate.id, @user.id, current_user.id)

      if user_invites.any? || @user.following?(current_user) || current_user?(@debate.user)
        @current_user_can_add = true
      else
        @current_user_can_add = false
      end
    end


  end

  def invitation
    @debate = Debate.find_by_id(params[:id])
    @debate_invite = @debate.debate_invites.build({sender_id: @debate.user})
    @debate_invites = DebateInvite.where('sender_id = ? AND debate_id = ?', @debate.user.id, @debate.id).paginate(page: params[:page], per_page: 10)
  
  end

  def index
    #@debates = Debate.paginate(page: params[:page], per_page: 10)
  end

  def search

    topics = params[:topic].split
    to_search = []
    topics.each do |topic|
      if topic[0] == '#'
        topic.slice!(0)
      end
      to_search << topic
    end
    
    @debates = Debate.tagged_with(to_search, any: true).paginate(page: params[:page], per_page: 10)
    if @debates.size > 0
      #flash.now[:success] = "found #{@users.size} people with name like #{name}!"
      #render :index
      @section_title = "matching conversation(s)"
      render :index
    else
      flash[:error] = "matching conversations not found!"
      redirect_to debates_path
    end
  end

  def allow_joining_private_conversation
    notification = Notification.find_by_id(params[:id])
    if !notification
      redirect_to notifications_path
      return
    end
    join_request = JoinRequest.find(notification.unknown_object_id, include: :user)
    user = join_request.user
    debate = join_request.debate
    #flash[:notice] = "inviting #{user.name} to #{debate.content}"

    debate_invite = debate.debate_invites.build({
      email: user.email,
      message: "Hi #{user.name.downcase}! Please do join my conversation. :-)",
      debate_id: debate.id,
      sender_id: current_user.id,
      receiver_id: user.id 
      })

    if debate_invite.save
      notification.destroy
      participation = debate_invite.debate.participations.create({user_id: user.id})
      new_notification = {
          classname: debate_invite.class.name,
          unknown_object_id: debate_invite.id
      }
        
      if user.notify(new_notification)
        flash[:success] = "#{user.name.downcase} has been allowed to join your private conversation!"
        UserMailer.invitation_for_debate(debate_invite).deliver
      else
        flash[:error] = "Problemo!!!"
      end
        
      
    else
      flash[:error] = "There was a problem in processing your request! Please try again sometime later."
    end
    redirect_to notifications_path

    
  end

   private

    def correct_user
      @debate = current_user.debates.find_by_id(params[:id])
      redirect_to root_path if @debate.nil?
    end
end