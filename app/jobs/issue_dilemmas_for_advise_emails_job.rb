# Email No. 15

class IssueDilemmasForAdviseEmailsJob < ActiveJob::Base
  queue_as :default

  def perform
    users = User.where(role: 'guru')

    users.each do |user|
      categories = user.profile.category_list
      dilemmas = DilemmasForAdviceEmailQuery.new(user,categories).results

      if dilemmas.present?
        UserMailer.dilemmas_for_advise(user, dilemmas).deliver_later
      end
    end
  end
end
