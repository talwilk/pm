class TrendingDilemmaQuery
  def initialize(dilemma_range)
    @dilemma_range = dilemma_range
  end

  def results
    results = @dilemma_range.select("*, (select count(*) from votes where votes.votable_type='DilemmaAdvice' and votes.votable_id in (select dilemma_advices.id from dilemma_advices where dilemma_advices.deleted_at is null and dilemma_advices.dilemma_id=dilemmas.id)) as counter_cache").order("counter_cache desc")
    results
  end
end
