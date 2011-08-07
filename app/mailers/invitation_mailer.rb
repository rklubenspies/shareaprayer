class InvitationMailer < ActionMailer::Base
  def invite(invitation)
    @invite = invitation
    mail :from => 'robert.klubenspies@gmail.com',
         :to => invitation.email,
         :subject => "Welcome to Share a Prayer"
  end
end
