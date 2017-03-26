class SuperAdminDilemmaAdviceQuery
  attr_accessor :params, :search

  def initialize(params = {})
    @params = params
    normalize_filters
  end

  def results
    results = DilemmaAdvice.with_deleted.all
    results = results.where('content ILIKE ?', "%#{@search}%")
    results = results.order('dilemma_advices.id desc')

    results
  end

  private

  def normalize_filters
    @search = params[:search]
  end
end
