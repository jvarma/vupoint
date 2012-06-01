class JoinRequest < ActiveRecord::Base
  	attr_accessible :user_id # The requestor
  	validates :debate_id, presence: true
  	validates :user_id, presence: true
  	validates :user_id, uniqueness: {scope: [:debate_id]}
  	belongs_to :user
  	belongs_to :debate

  	def message_tokens
  		name = User.find(self.user_id).name.downcase
  		debate_content = self.debate.content
  		[name, debate_content]
  	end
end
