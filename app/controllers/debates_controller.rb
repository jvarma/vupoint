class DebatesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def create
  	@debate = current_user.debates.build(params[:debate])
    if @debate.save
      	flash[:success] = "A new topic created!"
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
    @user = @debate.user
    @viewpoint = @debate.viewpoints.build
    if current_user?(@user)
      @viewpoints = @debate.viewpoints.paginate(page: params[:page], per_page: 10)
    else
      @viewpoints = @debate.viewpoints.published.paginate(page: params[:page], per_page: 10)
    end

    @current_user_can_add = false

    debate_invites_user_to_cu_for_curr_debate = DebateInvite.where(
      'debate_id = ? AND sender_id = ? AND receiver_id = ?', 
      @debate.id, @user.id, current_user.id)

    if debate_invites_user_to_cu_for_curr_debate.any?
      @current_user_can_add = true
    end

    if @user.following?(current_user)
      @current_user_can_add = true
    end


  end

  def invitation
    @debate = Debate.find_by_id(params[:id])
    @debate_invite = @debate.debate_invites.build({sender_id: @debate.user})
    @debate_invites = DebateInvite.where('sender_id = ? AND debate_id = ?', @debate.user.id, @debate.id).paginate(page: params[:page], per_page: 10)
  
  end

   private

    def correct_user
      @debate = current_user.debates.find_by_id(params[:id])
      redirect_to root_path if @debate.nil?
    end
end