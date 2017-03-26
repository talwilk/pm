# Email No. 8

class IssueFirstDilemmaSolvedEmailsJob < ActiveJob::Base
  queue_as :default

  def perform
    users = FirstDilemmaSolvedEmailQuery.new.results

    users.each do |user|
      UserMailer.first_dilemma_solved(user).deliver_later

      user.update_attributes(first_dilemma_solved: true)
    end
  end
end
