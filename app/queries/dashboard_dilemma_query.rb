class DashboardDilemmaQuery
  attr_accessor :params, :search, :dilemmas, :category, :sort_by

  def initialize(params)
    @params = params
    @user = params[:user]
    @search = params[:search]
    @dilemmas = params[:dilemmas]
    @category = params[:category]
    @sort_by = params[:sort_by]
  end

  def results
    prepare_results
    filter_by_status
    filter_by_category
    sort

    @results
  end

  private

  def prepare_results
    @results = Dilemma.all

    search_by_dilemmas = @results.where('title || description ILIKE ?', "%#{search}%")
    search_by_advices = @results.includes(:advices).where('dilemma_advices.content ILIKE ?', "%#{search}%").references(:dilemma_advices)

    all_searches = search_by_dilemmas + search_by_advices

    all_searches.map{ |i| i.id }
    @results = @results.where(id: all_searches)
  end

  def filter_by_status
    if dilemmas.present?
      if dilemmas == "open"
        @results = @results.where("ends_at > ?", Time.zone.now)
      elsif dilemmas == "closed"
        @results = @results.where("ends_at < ?", Time.zone.now)
      end
    end
  end

  def filter_by_category
    @results = @results.tagged_with(category, :any => true) unless category.blank?
  end

  def sort
    if sort_by == 'newest'
      @results = @results.order('dilemmas.created_at desc')
    elsif sort_by == 'least_advised'
      @results = @results.order("(select count(*) from dilemma_advices where dilemma_id = dilemmas.id) asc")
    elsif sort_by == 'most_liked'
      @results = TrendingDilemmaQuery.new(@results).query_outcome
    elsif sort_by == 'ending_soon'
      @results = @results.where("ends_at > ?", Time.zone.now)
      @results = @results.order('ends_at asc')
    elsif sort_by == 'most_advised'
      @results = @results.order("(select count(*) from dilemma_advices where dilemma_id = dilemmas.id) desc")
    elsif sort_by == 'my_dilemmas'
      if @user.dilemmas.count > 0
        @results = @results.where('user_id = ?', @user.id).order('dilemmas.created_at desc')
      else
        @results = @results.order('dilemmas.created_at desc')
      end
    end
  end
end
