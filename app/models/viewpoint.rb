class Viewpoint < ActiveRecord::Base
  	attr_accessible :debate_id, :desc, :updated_at, :votes

  	belongs_to :debate

  	has_many :arguments

  	validates :desc, presence: true, length: { maximum: 140 }

	default_scope order: 'viewpoints.votes DESC'
	default_scope order: 'viewpoints.updated_at DESC'

	def argument_feed(is_up_vote)
		if is_up_vote.nil?
			Argument.by_viewpoint(self)
		else
			Argument.by_votes(self, is_up_vote)
		end
	end


	def update_attributes(attr_hash)
		super(attr_hash)
		@debate = Debate.find(self.debate_id)
		@debate.update_attributes(updated_at: Time.now)
	end

end
