class Viewpoint < ActiveRecord::Base
  	attr_accessible :debate_id, :desc

  	belongs_to :debate

  	validates :desc, presence: true, length: { maximum: 140 }

	default_scope order: 'viewpoints.created_at DESC'

end
