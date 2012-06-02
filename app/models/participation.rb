class Participation < ActiveRecord::Base
  	attr_accessible :user_id
  	belongs_to :user
  	belongs_to :debate
  	validates :debate_id, presence: true
  	validates :user_id, presence: true
	validates :user_id, uniqueness: {scope: [:debate_id]}
	
	#after_save :notify_participants
	
	
	
	def notify_participants
		participations = Participation.where('debate_id = ? AND user_id != ?', 
			self.debate, self.user)
		
		notification = {
			classname: self.class.name,
			unknown_object_id: self.id
		}

		participations.each do |participation|
			receiver = participation.user
			receiver.notify(notification)
		end

	end
end
