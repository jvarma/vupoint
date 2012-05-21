class Argument < ActiveRecord::Base
  	attr_accessible :content, :user_id, :viewpoint_id, :is_up_vote
  	belongs_to :viewpoint
  	belongs_to :user

  	before_save :content_length

  	validates :content, presence: true, length: { maximum: 500 }
  	validates :user_id, presence: true

	default_scope order: 'arguments.created_at DESC'


  	scope :by_votes, lambda { |viewpoint, is_up_vote| where('(viewpoint_id = ?) AND (is_up_vote = ?)', viewpoint.id, is_up_vote) }
 
 	scope :by_viewpoint, lambda { |viewpoint| where('viewpoint_id = ?', viewpoint.id)} 	

 	private

 		def content_length
 			
 		end 

end
