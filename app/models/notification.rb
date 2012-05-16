class Notification < ActiveRecord::Base
  	attr_accessible :message, :classname, :unknown_object_id

  	belongs_to :user

  	validates :message, presence: true

  	validates :user_id, presence: true

	default_scope order: 'notifications.created_at DESC'


  	def message_tokens
  		unknown_object = Kernel.const_get(self.classname).find_by_id(self.unknown_object_id)
  		if unknown_object.nil?
  			nil
  		else
  			unknown_object.message_tokens
  		end
	end

end
