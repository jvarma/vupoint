class ArgumentsController < ApplicationController
  before_filter :signed_in_user
  before_filter :force_mobile
  
  def new
  	@viewpoint = Viewpoint.find(params[:viewpoint])
    @user = @viewpoint.debate.user
    params[:is_up_vote] ? (@is_up_vote = true) : (@is_up_vote = false)  	
    @argument = @viewpoint.arguments.build
    @argument_items = @viewpoint.argument_feed(@is_up_vote).paginate(page: params[:page], per_page: 10)

  end

  def create

    @viewpoint = Viewpoint.find(params[:argument][:viewpoint_id])
    
    #@user = User.find(params[:argument][:user_id])
    #@true = params[:argument][:is_up_vote]

    @argument = @viewpoint.arguments.build(params[:argument])
    if params[:commit] == 'vote up!'
      @argument.is_up_vote = true
    elsif params[:commit] == 'vote down!'
      @argument.is_up_vote = false
    end
    
    if @argument.save
        votes = @viewpoint.votes
        if @argument.is_up_vote
          votes = votes + 1
        else
          votes = votes - 1
        end

        #notify the vupnt owner
        #code to be written
        
        @viewpoint.update_attributes(votes: votes)
        flash[:success] = "Your vote has been posted!"
    else
        flash[:error] = "Your vote could not be posted."
    end
    #redirect_to debate_path @argument.viewpoint.debate
    redirect_to arguments_path({viewpoint: @viewpoint})
  end

  def destroy
    argument = Argument.find(params[:id])
    viewpoint = argument.viewpoint
    votes = viewpoint.votes
    if argument.is_up_vote
      votes = votes - 1
    else
      votes = votes + 1
    end
    argument.destroy
    viewpoint.update_attributes({votes: votes})
    redirect_to debate_path(viewpoint.debate)
  end

  def index
    @viewpoint = Viewpoint.find(params[:viewpoint])
    @argument = @viewpoint.arguments.build
    @argument_items = @viewpoint.argument_feed(nil).paginate(page: params[:page], per_page: 10)
    @user = @viewpoint.debate.user
  end
end
