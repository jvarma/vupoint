# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation, :confirmed_at

	has_secure_password

	before_save { |user| user.email = email.downcase }

	before_save :set_name_tags

	before_save :create_remember_token, :create_confirmation_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, presence: true, length: { maximum: 30 }

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }

	validates :password, length: { minimum: 6 }, :if => :password_validation_required?

	validates :password_confirmation, presence: true, :if => :password_validation_required?

	# user has debates, viewpoints and arguments
	has_many :debates, dependent: :destroy
	has_many :viewpoints, dependent: :destroy
	has_many :arguments, dependent: :destroy
	has_many :notifications, dependent: :destroy
	has_many :invitations, dependent: :destroy # invitations to join vupnt, sent by the user
	
	# user has followers and as well as those that the user follows through relationships
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  	has_many :followers, through: :reverse_relationships, source: :follower


  	# user sends invites and is receiver of invites
	has_many :debate_invites, foreign_key: "sender_id", dependent: :destroy
	has_many :invited_users, through: :debate_invites, source: :receiver
	has_many :reverse_debate_invites, foreign_key: "receiver_id",
    								class_name: "DebateInvite",
    								dependent: :destroy
  	has_many :invite_senders, through: :reverse_debate_invites, source: :sender

  	acts_as_taggable

  	#acts_as_taggable_on :debates, :viewpoints, :arguments

  	scope :admin, where(admin: true)

  	#scope :by_name, lambda { |name| where("name LIKE ?", %w(#{name})) }

	#scope :by_name, lambda { |name| where('UPPER(name) LIKE %?%', name.upcase) }

	scope :by_name, lambda { |name| where('name LIKE ?', name) }

	# methods

	def password_validation_required?
  		password_digest.blank? || !@password.blank?
	end

	def feed(featured=false)
		if !featured
			Debate.from_users_followed_by(self)
		else
			Debate.from_admin
		end
	end

	def following?(other_user)
    	relationships.find_by_followed_id(other_user.id)
  	end

  	def follow!(other_user)
    	relationships.create!(followed_id: other_user.id)
    	# send a notification to the other_user
    	#notification = other_user.notifications.build({
		#			message: nil, classname: self.class.name,
		#			unknown_object_id: self.id})

		notification_params = {
					classname: self.class.name,
					unknown_object_id: self.id
				}
		#notification.save

		other_user.notify(notification_params)
		
  	end
	
	def unfollow!(other_user)
    	relationships.find_by_followed_id(other_user.id).destroy
	end

	def message_tokens
		sender_name = self.name.downcase
		message_tokens = [sender_name]
	end

	def notify(notification_params)
		notification = self.notifications.build(notification_params)
		notification.save!
	end

	def to_param
      "#{self.id}-#{self.name.parameterize}" 
    end

	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end

		def create_confirmation_token
			unless self.confirmed_at
				self.confirmation_token = Digest::SHA1.hexdigest([Time.now, rand].join)
			end

		end


		def self.by_name(name)
      		user_ids = []
      		users = User.all

      		users.each do |user|
        		user_ids << user.id
      		end

      		where(name: name)
		end


		def set_name_tags
			name = self.name
			name_tags = name.split.join(",")
			self.tag_list = name_tags
		end

end











