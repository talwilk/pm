class GuruApplicationQuery
  attr_accessor :params, :search, :guru_app_filter, :sort_by

  def initialize(params = {})
    @params = params
    normalize_filters
  end

  def results
    results = GuruApplication.all
    results = results.where("guru_applications.user_id in (select user_id from user_profiles where user_profiles.first_name ILIKE '%#{@search}%' or user_profiles.last_name ILIKE '%#{@search}%')")
    results = filter_results(results)
    results = sort_results(results)
    results
  end

  private

  def normalize_filters
    @search = params[:search]
    @guru_app_filter = params[:guru_app_filter]
    @sort_by = params[:sort_by]
  end

  def filter_results(results)
    @results = results
    if guru_app_filter == 'pending'
      @results = @results.pending
    elsif guru_app_filter == 'being_reviewed'
      @results = @results.being_reviewed
    elsif guru_app_filter == 'accepted'
      @results = @results.accepted
    elsif guru_app_filter == 'rejected'
      @results = @results.rejected
    end
    @results
  end

  def sort_results(results)
    @results = results
    if sort_by == 'oldest'
      @results = @results.order('id asc')
    elsif sort_by == 'last_name_a_z'
      @results = @results.joins(:user).joins(user: :profile).order('user_profiles.last_name ASC')
    elsif sort_by == 'last_name_z_a'
      @results = @results.joins(:user).joins(user: :profile).order('user_profiles.last_name DESC')
    else
      @results = @results.order('id desc')
    end
    @results
  end
end
