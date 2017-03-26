class DailyWelcomeEmailQuery
  def results
    User.where('last_sign_in_at >= ?', (Time.zone.now - 10.days).beginning_of_day).
      where('last_sign_in_at <= ?', (Time.zone.now - 10.days).end_of_day).
      where(role: 'regular').
      joins('LEFT JOIN dilemmas ON dilemmas.user_id = users.id').
      group('users.id').
      having('COUNT(dilemmas.id) = 0').
      joins('LEFT JOIN dilemma_advices ON dilemma_advices.user_id = users.id').
      group(' users.id').
      having('count(dilemma_advices.id) = 0')
  end
end
