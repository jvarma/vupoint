class ArgumentsController < ApplicationController
  before_filter :signed_in_user
  
  def new
  	@viewpoint = Viewpoint.find(params[:viewpoint])
    @user = @viewpoint.debate.user
    params[:is_up_vote] ? (@is_up_vote = true) : (@is_up_vote = false)  	
    @argument = @viewpoint.arguments.build

    @argument_items = @viewpoint.argument_feed(@is_up_vote).paginate(page: params[:page], per_page: 10)

    desc = @viewpoint.desc
    user_name = @user.name
    is_up_vote = @is_up_vote
    argument_items_size = @argument_items.any?

    flash[:notice] = "#{desc} - #{user_name} - #{is_up_vote} - #{argument_items_size}"

  end

  def create

    @viewpoint = Viewpoint.find(params[:argument][:viewpoint_id])
    
    #@user = User.find(params[:argument][:user_id])
    #@true = params[:argument][:is_up_vote]

    @argument = @viewpoint.arguments.build(params[:argument])
    

    if @argument.save
        votes = @viewpoint.votes
        if @argument.is_up_vote
          votes = votes + 1
        else
          votes = votes - 1
        end
        @viewpoint.update_attributes(updated_at: Time.now, votes: votes)
        flash[:success] = "You have made a point!"
    else
        flash[:error] = "Your argument could not be posted."
    end
    redirect_to debate_path @argument.viewpoint.debate

  end

  def destroy
  end

  def index
  	@viewpoint = Viewpoint.find(params[:viewpoint])

    @argument_items = @viewpoint.argument_feed(nil).paginate(page: params[:page], per_page: 10)

  	if !@argument_items.any?
  		flash[:notice] = "There is no buzz around the vupnt! Vote up a vupnt if you agree with it or down, if you disagree."
  		redirect_to debate_path(@viewpoint.debate)
  	end
  end
end
