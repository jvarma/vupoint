class Viewpoint < ActiveRecord::Base
  	attr_accessible :debate_id, :desc, :updated_at, :votes, :user_id, :published

  	belongs_to :debate, touch: true

  	belongs_to :user, touch: true

  	has_many :arguments

  	validates :desc, presence: true, length: { maximum: 140 }

  	validates :user_id, presence: true

	default_scope order: 'viewpoints.votes DESC'
	default_scope order: 'viewpoints.updated_at DESC'
	scope :published, lambda {where('published = ?', true)}

	after_save :update_debate_updated_at

	before_save :desc_length

	def argument_feed(is_up_vote)
		if is_up_vote.nil?
			Argument.by_viewpoint(self)
		else
			Argument.by_votes(self, is_up_vote)
		end
	end

	def votes_by_type
		positive_votes = 0
		negative_votes = 0
		arguments = self.arguments
		unless !arguments
			arguments.each do |argument|
				if argument.is_up_vote
					positive_votes += 1
				else
					negative_votes += 1
				end
			end
		end
		{positive: positive_votes, negative: negative_votes}
	end


	#def update_attributes(attr_hash)
	#	super(attr_hash)
	#	@debate = Debate.find(self.debate_id)
	#	@debate.update_attributes(updated_at: Time.now)
	#end

	def message_tokens
      	vupnt_user_name = User.find_by_id(self.user_id).name.downcase 
      	debate_content = Debate.find_by_id(self.debate_id).content
      	vupnt_desc = self.desc 
		message_tokens = [vupnt_user_name, debate_content, vupnt_desc]
    end


	private

		def update_debate_updated_at
			if self.published
				self.debate.update_attributes(updated_at: Time.now)
			end

		end

		def desc_length
 			
 		end


end
