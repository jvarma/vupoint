class DebateInvite < ActiveRecord::Base

  	attr_accessible :debate_id, :email, :message, :receiver_id, :sender_id

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  	belongs_to :sender, class_name: "User"
  	belongs_to :receiver, class_name: "User"
  	belongs_to :debate

  	validates :sender_id, presence: true # receiver_id can be NULL

  	validates :debate_id, presence: true

  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  	validates :email, uniqueness: {scope: [:sender_id, :debate_id]}

  	validates :message, length: { maximum: 140 }

    before_destroy :delete_notifications

    before_save :message_length

    def message_tokens
      sender = User.find_by_id(self.sender_id)
      if sender.nil?
        return nil
      else
        sender_name = sender.name
      end

      debate = Debate.find_by_id(self.debate_id)
      if debate.nil?
        return nil
      else
        debate_content = debate.content
      end
      self.message ? (message = self.message) : (message = nil)
      message_tokens = [sender_name, debate_content, message]
    end

    private

      def delete_notifications
        notifications = Notification.where('unknown_object_id = ? 
          AND classname = ?', self.id, self.class.name)
        notifications.each do |notification|
          notification.destroy
        end        
      end

      def message_length
      end
  
end
