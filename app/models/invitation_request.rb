class InvitationRequest < ActiveRecord::Base
	attr_accessible :city, :country, :email, :name

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, presence: true, length: { maximum: 30 }

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }

	validates :city, length: { maximum: 50 }

	def message_tokens
      name = self.name
      email = self.email
      city = self.city
      message_tokens = [name, email, city]
    end


end
