class Viewpoint < ActiveRecord::Base
  	attr_accessible :debate_id, :desc, :updated_at, :votes, :user_id, :published

  	belongs_to :debate

  	belongs_to :user

  	has_many :arguments

  	validates :desc, presence: true, length: { maximum: 140 }

  	validates :user_id, presence: true

	default_scope order: 'viewpoints.votes DESC'
	default_scope order: 'viewpoints.updated_at DESC'
	scope :published, lambda {where('published = ?', true)}

	after_save :update_debate_updated_at

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


end
