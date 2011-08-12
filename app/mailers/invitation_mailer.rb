class InvitationMailer < ActionMailer::Base
  def invite(invitation)
    @invite = invitation
    mail :from => '"Share a Prayer" <noreply@shareaprayer.org>',
         :to => invitation.email,
         :subject => "Welcome to Share a Prayer"
  end
end
