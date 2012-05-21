class Invitation < ActiveRecord::Base
  	attr_accessible :email, :message, :name
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	
  	validates :user_id, presence: true

  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  	validates :message, length: { maximum: 140 }

  	validates :name, length: { maximum: 30 }

  	belongs_to :user # the one who sent it

  	before_save { |invitation| invitation.email = email.downcase }

    before_save :message_length

	before_save :create_confirmation_token

	private

		def create_confirmation_token
			self.confirmation_token = Digest::SHA1.hexdigest([Time.now, rand].join)
		end

    def message_length
      if message.length > 140
        message = message[0..139]
      end
    end


end
