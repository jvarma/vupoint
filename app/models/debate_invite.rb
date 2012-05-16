class DebateInvite < ActiveRecord::Base

  	attr_accessible :debate_id, :email, :message, :receiver_id, :sender_id

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  	belongs_to :sender, class_name: "User"
  	belongs_to :receiver, class_name: "User"
  	belongs_to :debate

  	validates :sender_id, presence: true # receiver_id can be NULL

  	validates :debate_id, presence: true

  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  	validates :email, uniqueness: {scope: [:sender_id, :debate_id]}

  	validates :message, length: { maximum: 200 }
  
end
