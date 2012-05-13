class Argument < ActiveRecord::Base
  	attr_accessible :content, :user_id, :viewpoint_id, :is_up_vote
  	belongs_to :viewpoint
  	belongs_to :user

  	validates :content, presence: true, length: { maximum: 500 }
  	validates :user_id, presence: true

	default_scope order: 'arguments.created_at DESC'


  	scope :by_votes, lambda { |viewpoint, is_up_vote| where('(viewpoint_id IS ?) AND (is_up_vote IS ?)', viewpoint.id, is_up_vote) }
 
 	scope :by_viewpoint, lambda { |viewpoint| where('viewpoint_id is ?', viewpoint.id)} 	



end
