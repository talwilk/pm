class SuperAdminUserQuery
  attr_accessor :params, :search, :user_type_filter, :user_country_filter, :sort_by

  def initialize(params = {})
    @params = params
    normalize_filters
  end

  def results
    results = User.with_deleted.all
    results = results.where("users.email ILIKE '%#{@search}%' OR (users.id in (select user_id from user_profiles where user_profiles.first_name ILIKE '%#{@search}%' or user_profiles.last_name ILIKE '%#{@search}%'))")
    results = filter_results(results)
    results = sort_results(results)
    results
  end

  private

  def normalize_filters
    @search = params[:search]
    @user_type_filter = params[:user_type_filter]
    @user_country_filter = params[:user_country_filter]
    @sort_by = params[:sort_by]
  end

  def filter_results(results)
    @results = results

    if user_type_filter == 'user'
      @results = @results.where(role: 'regular')
    elsif user_type_filter == 'guru'
      @results = @results.where(role: 'guru')
    end

    unless user_country_filter.blank?
      @results = @results.where(country_iso: user_country_filter)
    end

    @results
  end

  def sort_results(results)
    @results = results
    if sort_by == 'oldest'
      @results = @results.order('id asc')
    elsif sort_by == 'last_name_a_z'
      @results = @results.joins(:profile).order('user_profiles.last_name ASC')
    elsif sort_by == 'last_name_z_a'
      @results = @results.joins(:profile).order('user_profiles.last_name DESC')
    else
      @results = @results.order('id desc')
    end
    @results
  end
end
