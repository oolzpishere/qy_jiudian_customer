module Admin
  class ApplicationMailer < ActionMailer::Base
    # default from: 'from@example.com'
    layout 'mailer'
    # test
    def welcome_email
      mail(to: "page_lee@qq.com",
           from: "sendcloud@sendcloud.com",
           body: "email_body",
           content_type: "text/html",
           subject: "Already rendered!")
    end

  end
end
