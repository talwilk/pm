# Email No. 7

class IssueWelcomeEmailsJob < ActiveJob::Base
  queue_as :default

  def perform
    users = DailyWelcomeEmailQuery.new.results

    users.each do |user|
      UserMailer.welcome_email(user).deliver_later
    end
  end
end
