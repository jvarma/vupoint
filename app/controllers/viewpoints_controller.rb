class ViewpointsController < ApplicationController
  def create
  	@debate = Debate.find(params[:viewpoint][:debate_id])
  	@viewpoint = @debate.viewpoints.build(params[:viewpoint])

  	if @viewpoint.save
      @debate.update_attributes(updated_at: Time.now)
      flash[:success] = "Your view has been posted!"
  	else
      flash[:error] = "Something went wrong!#{@viewpoint.debate_id} - #{@viewpoint.desc}"
    end

    redirect_to debate_path @debate

  end

  
  def destroy
  	@viewpoint = Viewpoint.find(params[:id])
  	@debate = @viewpoint.debate
  	@viewpoint.destroy
    redirect_to debate_path @debate 
  end
end
