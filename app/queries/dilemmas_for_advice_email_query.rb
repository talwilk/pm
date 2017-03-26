class DilemmasForAdviceEmailQuery
  def initialize(user,categories)
    @categories = categories
    @user = user
  end

  def results
    dilemmas_for_advice
  end

  private

  def dilemmas_for_advice
    dilemmas = Dilemma.where('ends_at > ?', Time.zone.now).
      includes(:user).where(users: {country_iso: @user.country_iso}).
      joins('LEFT JOIN dilemma_advices ON dilemma_advices.dilemma_id=dilemmas.id').
      group('dilemma_advices.user_id, users.id, dilemmas.id').
      having('count(dilemma_advices.id) = 0').
      tagged_with(@categories, :any => true).
      order("RANDOM()").
      first(10)
    dilemmas
  end
end
