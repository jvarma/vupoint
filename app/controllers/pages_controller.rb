class PagesController < ApplicationController

before_filter :force_mobile, except: :home

before_filter :admin_user, only: :stats


  
  def home

  	if signed_in?

     
  		@debate = current_user.debates.build
  		@feed_items = current_user.feed(include: :user).paginate(page: params[:page], per_page: 10)
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

  def stats
    
    @user_count_total = User.count
    @user_count_24_hrs_1 = User.where('created_at > ?', Time.now - 24.hours).size
    @user_count_24_hrs_2 = User.where('created_at <= ? AND created_at > ?',
      Time.now - 24.hours, Time.now - 48.hours).size
    @user_count_24_hrs_3 = User.where('created_at <= ? AND created_at > ?',
      Time.now - 48.hours, Time.now - 72.hours).size
    
    @debate_count_total = Debate.count
    @debate_count_24_hrs_1 = Debate.where('created_at > ?', Time.now - 24.hours).size
    @debate_count_24_hrs_2 = Debate.where('created_at <= ? AND created_at > ?',
      Time.now - 24.hours, Time.now - 48.hours).size
    @debate_count_24_hrs_3 = Debate.where('created_at <= ? AND created_at > ?',
      Time.now - 48.hours, Time.now - 72.hours).size

    @viewpoint_count_total = Viewpoint.count
    @viewpoint_count_24_hrs_1 = Viewpoint.where('created_at > ?', Time.now - 24.hours).size
    @viewpoint_count_24_hrs_2 = Viewpoint.where('created_at <= ? AND created_at > ?',
      Time.now - 24.hours, Time.now - 48.hours).size
    @viewpoint_count_24_hrs_3 = Viewpoint.where('created_at <= ? AND created_at > ?',
      Time.now - 48.hours, Time.now - 72.hours).size

    
    @argument_count_total = Argument.count
    @argument_count_24_hrs_1 = Argument.where('created_at > ?', Time.now - 24.hours).size
    @argument_count_24_hrs_2 = Argument.where('created_at <= ? AND created_at > ?',
      Time.now - 24.hours, Time.now - 48.hours).size
    @argument_count_24_hrs_3 = Argument.where('created_at <= ? AND created_at > ?',
      Time.now - 48.hours, Time.now - 72.hours).size

  end


  private

    def admin_user
      if signed_in?
        redirect_to root_path unless current_user.admin?
      end
    end


  
end
