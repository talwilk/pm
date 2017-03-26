class FirstDilemmaSolvedEmailQuery
  def results
    User.select("users.*").
      where(first_dilemma_solved: false).
      joins(dilemmas: :advices).
      where('dilemmas.ends_at >= ?', Time.zone.now - 1.day).
      where('dilemmas.ends_at <= ?', Time.zone.now).
      uniq
  end
end
