class Participation < ActiveRecord::Base
  	attr_accessible :user_id
  	belongs_to :user
  	belongs_to :debate
  	validates :debate_id, presence: true
  	validates :user_id, presence: true
	validates :user_id, uniqueness: {scope: [:debate_id]} 
end
