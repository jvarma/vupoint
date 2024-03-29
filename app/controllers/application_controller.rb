class ApplicationController < ActionController::Base
    helper :all
    protect_from_forgery
    include SessionsHelper
    include DebatesHelper
    include NotificationsHelper
    include InvitationRequestsHelper
    
    before_filter :prepare_for_mobile

    private
    
    def mobile_device?
    	if session[:mobile_param]
        	session[:mobile_param] == "1"
      	else
        	request.user_agent =~ /Mobile|nokia|blackberry|android|iphone/i
      	end
    end
    
    helper_method :mobile_device?

    def prepare_for_mobile
      	session[:mobile_param] = params[:mobile] if params[:mobile]
    	request.format = :mobile if mobile_device?
    end

    def force_mobile
        if request.format != :mobile
            flash[:notice] = "vupnt is currently available only for mobile browsers!"
            redirect_to root_path
        end
    end

end
