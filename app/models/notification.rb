class Notification < ActiveRecord::Base
  	attr_accessible :message, :classname, :unknown_object_id

  	belongs_to :user

  	validates :message, length: { maximum: 140 }

  	validates :user_id, presence: true

    default_scope order: 'notifications.created_at DESC'

    before_save :clean_up!


  	def message_tokens
  		unknown_object = Kernel.const_get(self.classname).find_by_id(self.unknown_object_id)
  		if unknown_object.nil?
  			nil
  		else
  			unknown_object.message_tokens
  		end
    end

    private
      def clean_up!
        #keep hundred notifications per user
        notifications = Notification.where('user_id = ?', self.user_id)
        if notifications.size >= 25
          notifications.last.destroy
        end
      end

end
