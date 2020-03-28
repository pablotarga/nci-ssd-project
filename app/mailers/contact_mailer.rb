class ContactMailer < ActionMailer::Base
  default from: 'contact@ncirl.ie'

  def contact_email(name, email, message)
      @name = name
      @email = email
      @message = message

      mail(to: 'x19181965@student.ncirl.ie', subject: 'Contact Request')
  end
end
