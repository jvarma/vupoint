class Debate < ActiveRecord::Base

  	attr_accessible :content, :updated_at, :is_private

  	belongs_to :user, touch: true
  
  	validates :user_id, presence: true

  	validates :content, presence: true, length: { maximum: 140 }
  
  	default_scope order: 'debates.updated_at DESC'

  	# Returns microposts from the users being followed by the given user.
  	#scope :from_users_followed_by, lambda { |user| followed_by(user) }

    has_many :viewpoints, dependent: :destroy

    has_many :debate_invites, dependent: :destroy

    has_many :participations, dependent: :destroy

    has_many :join_requests, dependent: :destroy
    # requests received to join this debate

    acts_as_taggable

    before_save :set_hash_tags, :content_length


    def has_invited?(sender, receiver)
      debate_invites = DebateInvite.where('debate_id = ? AND sender_id = ? AND receiver_id = ?',
        self.id, sender.id, receiver.id)
      if debate_invites.any?
        true
      else
        false
      end
    end

    def has_participant?(user)
      if !user
        return user
      elsif !self.is_private
        return true
      else
        participations = Participation.where('debate_id = ? AND user_id = ?', self.id, user.id)
        if participations.any?
          return true
        else
          return false
        end
      end
      
    end


    def to_param
      "#{self.id}-#{self.content.parameterize}" 
    end

private


    def self.from_users_followed_by(user)
      followed_user_ids = user.followed_user_ids
      Debate.where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    end

    def set_hash_tags
      all_tags = self.content.split
      hash_tags = []
      all_tags.each do |tag|
        if tag[0] == '#'
          tag.slice!(0)
          hash_tags << tag
        end
      end
      self.tag_list = hash_tags.join(",")
    end

    def content_length
      
    end


end
