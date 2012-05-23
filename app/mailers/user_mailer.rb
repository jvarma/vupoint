class UserMailer < ActionMailer::Base
  default from: "izebrg@gmail.com"

  def confirm_email(user, feed)
  	@user = user
    @feed = feed
  	mail(to: user.email, subject: "Your view counts! Please confirm your email id.")
  end

  def invitation_for_debate(debate_invite)
    #@sender = User.find(debate_invite.sender_id)
    @sender = debate_invite.sender
    @debate = debate_invite.debate
    @receiver = User.find_by_id(debate_invite.receiver_id)
    if @receiver.nil?
      @invitation = @sender.invitations.create({email: debate_invite.email})
    end
    @message = debate_invite.message
    @email = debate_invite.email
    mail(to: @email, subject: "#{@sender.name} invites you to a debate!")
  end

  def invitation_to_vupnt(invite)
    @sender = invite.user
    @message = invite.message
    @email = invite.email
    @name = invite.name
    @invitation = invite
    mail(to: @email, subject: "#{@sender.name} invites you to join VUpnt!")
  end
end
