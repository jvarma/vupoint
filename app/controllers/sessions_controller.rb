class SessionsController < ApplicationController

  before_filter :force_mobile

	def new
		@title = "sign in"
	end

	def create
		user = User.find_by_email(params[:session][:email])
  		if confirmed_user?(user) && user.authenticate(params[:session][:password])
    	# Sign the user in and redirect to the user's show page.
    		sign_in user
    		redirect_back_or root_path
  		else
    	# Create an error message and re-render the signin form.
    		flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      	render :new
  		end
	end

	def destroy
    sign_out
    redirect_to root_path
	end
end
