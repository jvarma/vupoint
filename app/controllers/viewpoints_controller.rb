class ViewpointsController < ApplicationController


  def create
  	@debate = Debate.find(params[:viewpoint][:debate_id])
  	@viewpoint = @debate.viewpoints.build(params[:viewpoint])

  	if @viewpoint.save
      if @viewpoint.published
        flash[:success] = "Your view has been posted!"
      else
        flash[:success] = "Your vupnt has been shared with #{@debate.user.name.downcase}"
      end

      # send notification to debate owner
      # debate owner is the receiver of the notification
      # but only if current user is different from debate owner

      receiver = @debate.user
      unless current_user?(receiver)
        @message = "#{@viewpoint.user.name.downcase} has a new vupnt on your debate: #{@debate.content}" 
        notification = receiver.notifications.build({
          message: @message, classname: @viewpoint.class.name,
          unknown_object_id: @viewpoint.id})
        notification.save
      end




  	else
      flash[:error] = "Something went wrong!#{@viewpoint.debate_id} - #{@viewpoint.desc}"
    end

    redirect_to debate_path @debate

  end

  def publish
    @viewpoint = Viewpoint.find(params[:id])
    if current_user == @viewpoint.debate.user
      @viewpoint.update_attributes(published: true)
      flash[:success] = "the vupnt is now published and visible to all!"
    else
      flash[:error] = "you can publish vupnts on your own debates only!"
    end
    redirect_to debate_path(@viewpoint.debate)
  end

  
  def destroy
  	@viewpoint = Viewpoint.find(params[:id])
  	@debate = @viewpoint.debate
  	@viewpoint.destroy
    redirect_to debate_path @debate 
  end
end
