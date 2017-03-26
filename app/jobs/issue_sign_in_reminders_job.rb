# Email No. 16 and 17

class IssueSignInRemindersJob < ActiveJob::Base
  queue_as :default

  def perform
    users = User.where('last_sign_in_at >= ?', (Time.zone.now - 30.days).beginning_of_day).
      where('last_sign_in_at <= ?', (Time.zone.now - 30.days).end_of_day)

    users.each do |user|
      if user.role == 'regular'
        UserMailer.missing_user(user).deliver_later
      elsif user.role == 'guru'
        UserMailer.missing_guru(user).deliver_later
      end
    end
  end
end
