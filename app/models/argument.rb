class Argument < ActiveRecord::Base
  	attr_accessible :content, :user_id, :viewpoint_id, :is_up_vote
  	belongs_to :viewpoint
  	belongs_to :user

  	validates :content, presence: true, length: { maximum: 500 }
  	validates :user_id, presence: true

	default_scope order: 'arguments.created_at DESC'


  	scope :by_votes, lambda { |viewpoint, is_up_vote| where('viewpoint_id is ? and is_up_vote is ?', viewpoint.id, is_up_vote) }



end
