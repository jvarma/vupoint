class Notification < ActiveRecord::Base
  	attr_accessible :message, :user_id

  	belongs_to :user

  	validates :message, presence: true

  	validates :user_id, presence: true

	default_scope order: 'notifications.created_at DESC'


  
end
