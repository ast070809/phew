class TestMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome()
    @url  = 'http://example.com/login'
    mail(to: 'ast0708@gmail.com', subject: 'Welcome to My Awesome Site')
  end
end
