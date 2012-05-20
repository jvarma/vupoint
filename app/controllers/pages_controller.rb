class PagesController < ApplicationController
  
  def home
  	if signed_in?
  		@debate = current_user.debates.build
  		@feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
      if !@feed_items.any?
        @feed_items = User.new.feed(true).paginate(page: params[:page], per_page: 10)
      end

      if !current_user.notifications.first.nil?
        last_notification_time = current_user.notifications.first.created_at
      end

      notifications_last_viewed = cookies[:notifications_last_viewed]

      if last_notification_time.nil?
        @has_new_notifications = false

      else
        if notifications_last_viewed.nil?
          @has_new_notifications = true
        else
          if last_notification_time > notifications_last_viewed
            @has_new_notifications = true
          else
            @has_new_notifications = false
          end
        end
      end



    else
      @feed_items = User.new.feed(true).paginate(page: params[:page], per_page: 10)
    end

  end

  def help
  	@title = "help"
  end

  def tou
  	@title = "terms of use"
  end
end
