class DilemmaQuery
  attr_accessor :params, :search, :dilemmas, :category, :sort_by

  def initialize(params = {})
    @params = params
    @search = params[:search]
    @dilemmas = params[:dilemmas]
    @category = params[:category]
    @sort_by = params[:sort_by]
  end

  def results
    results = Dilemma.all

    search_by_dilemmas = results.where('title || description ILIKE ?', "%#{search}%")
    search_by_advices = results.includes(:advices).where('dilemma_advices.content ILIKE ?', "%#{search}%").references(:dilemma_advices)

    all_searches = search_by_dilemmas.pluck(:id) + search_by_advices.pluck(:id)

    results = results.where(id: all_searches)
    results = results.tagged_with(category, :any => true) unless category.blank?

    if dilemmas.present?
      if dilemmas == "open"
        results = results.where("ends_at > ?", Time.zone.now)
      elsif dilemmas == "closed"
        results = results.where("ends_at < ?", Time.zone.now)
      end
    end

    if sort_by == 'newest'
      results = results.order('dilemmas.created_at desc')
    elsif sort_by == 'most_advised'
      results = results.order("(select count(*) from dilemma_advices where dilemma_id=dilemmas.id) desc")
    elsif sort_by == 'least_advised'
      results = results.order("(select count(*) from dilemma_advices where dilemma_id=dilemmas.id) asc")
    elsif sort_by == 'most_liked'
      results = TrendingDilemmaQuery.new(results).query_outcome
    elsif sort_by == 'ending_soon'
      results = results.where('dilemmas.ends_at > ?', Time.zone.now)
      results = results.order('dilemmas.ends_at asc')
    end

    results
  end
end
