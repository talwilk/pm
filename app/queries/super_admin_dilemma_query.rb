class SuperAdminDilemmaQuery
  attr_accessor :params, :search

  def initialize(params = {})
    @params = params
    normalize_filters
  end

  def results
    results = Dilemma.all
    results = results.where('title || description ILIKE ?', "%#{@search}%")
    results = results.order('dilemmas.id desc')

    results
  end

  private

  def normalize_filters
    @search = params[:search]
  end
end
