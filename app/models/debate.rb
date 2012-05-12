class Debate < ActiveRecord::Base

  	attr_accessible :content, :updated_at

  	belongs_to :user
  
  	validates :user_id, presence: true

  	validates :content, presence: true, length: { maximum: 140 }
  
  	default_scope order: 'debates.updated_at DESC'

  	# Returns microposts from the users being followed by the given user.
  	scope :from_users_followed_by, lambda { |user| followed_by(user) }

    scope :from_admin, lambda { from_admin }

    has_many :viewpoints, dependent: :destroy

private

    # Returns an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      followed_user_ids = %(SELECT followed_id FROM relationships
                            WHERE follower_id = :user_id)
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
            { user_id: user })
    end

    def self.from_admin
      admin_ids = []
      admins = User.admin

      admins.each do |admin|
        admin_ids << admin.id
      end

      where(user_id: admin_ids)

    end


end
