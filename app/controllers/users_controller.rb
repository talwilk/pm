class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show]
  before_action :set_points_to_next_level, only: [:show, :dashboard]
  before_action :set_env, only: [:index]

  def index
    @users = User.all
  end

  def show
    @user_dilemmas = Dilemma.where(user_id: @user.id).order(created_at: :desc).page(params[:dilemma_page]).per(USER_PROFILE_PER_PAGE)
    @dilemmas_with_user_advices = Dilemma.distinct.joins(:advices).where(dilemma_advices: { user_id: @user.id }).order(created_at: :desc).page(params[:advice_page]).per(USER_PROFILE_PER_PAGE)
    @user_projets = Project.where(user_id: @user.id).order(created_at: :desc).page(params[:dilemma_page]).per(USER_PROFILE_PER_PAGE)
    respond_to do |format|
      format.js { render :show, layout: false }
      format.html
    end
  end

  def dashboard
    # Required for gamification widget
    @user = current_user

    # Set search defaults for different user types
    if !params.has_key?(:sort_by)
      params[:sort_by] = current_user.guru? ? "ending_soon" : "my_dilemmas"
    end

    if !params.has_key?(:category)
      params[:category] = current_user.guru? ? current_user.profile.categories : []
    end

    if !params.has_key?(:dilemmas)
      params[:dilemmas] = current_user.guru? ? "open" : "all"
    end

    @dilemma_query = DashboardDilemmaQuery.new(params.merge(user: current_user))
    @dilemmas = @dilemma_query.results.page(params[:page]).per(DEFAULT_PER_PAGE)

    @gurus = FeaturedGuruQuery.new.results
    @trending_dilemmas = TrendingDilemmaQuery.new(Dilemma.all).results
    @trending_dilemmas = @trending_dilemmas.first(2)

    if params[:load_more]
      @load_more = true
    end

    if (params[:sort_by] == 'my_dilemmas' || !params[:sort_by].present?) && current_user.dilemmas.count == 0
      @no_dilemmas = true
    end

    respond_to do |format|
      format.html
      format.js { render 'dashboard', layout: false }
    end
  end

  def dashboard_project
    @user = current_user
    puts "user #{@user.role}"
    if @user.role == 'regular'
      @user_projects = Project.where(user_id: @user.id).order(created_at: :desc).page(params[:dilemma_page]).per(USER_PROFILE_PER_PAGE)
      if !@user_projects.empty?
        @project = @user_projects.first
        puts "user profile - by user id"
      else
        @user_projects = Project.where(email: @user.email).order(created_at: :desc).page(params[:dilemma_page]).per(USER_PROFILE_PER_PAGE)
        if !@user_projects.empty?
          @project = @user_projects.first
          puts "user profile - by user email"
          @project.user_id = @user.id
          @project.save!
        end
      end
      if !@project.nil? 
        puts "project #{@project.id}"
        get_task_list
      else
        redirect_to wizard_path(:question_1)
      end
    else
      guru_dashboard
      render "guru_dashboard"
    end
  end

  def guru_dashboard
    
    @pros = Pro.where(email: @user.email)

    if @pros.count > 0
      @pros.each do |pro| 
        pro.user_id = @user.id
        pro.save!
      end
    end
    
    @tasks_hash = {}    
    
    @tasks = Task.joins(:pro).where('pros.user_id' => @user.id)
    #@tasks = Task.where(pro_id: pro.id).order(created_at: :desc).page(params[:dilemma_page]).per(USER_PROFILE_PER_PAGE)  

    if !@tasks.nil?
      @tasks.order(:project_id, :code)
      
      @tasks.each do |t|
        case t.status
          when 'not_started'
            t.image_url = "wizard/pending.png"
          when 'in_progress'
            t.image_url = "wizard/in_progress.png"
          when 'completed'
            t.image_url = "wizard/completed.png"
          else
            t.image_url = "Error"
        end

        @project = Project.where(id: t.project_id).first
        @customer = User.where(id: @project.user_id).first
        @customer_profile = UserProfile.where(id: @customer.id).first
        @project_string =  @project.id.to_s + "|" + @project.name + "|" + @project.address + "|" + @customer_profile.full_name
        puts "project string #{@project_string}"

        dilemma_array(t)

        #@tasks_hash[t.project_id] ||= {}
        @tasks_hash[@project_string] ||= {}
        #@tasks_hash[t.project_id] ||= []
        #@tasks_hash[t.project_id] << @project_string
        @tasks_hash[@project_string][t.id] ||= []
          @tasks_hash[@project_string][t.id] << t 
      end
    #@tasks_hash = @tasks_hash.sort_by {|a,b| a }
    end  
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_points_to_next_level
    if current_user.level < SupportedUserLevel.last_level
      @next_level = SupportedUserLevel.find(current_user.level+1)
      @points_to_next_level = SupportedUserLevel.upgrade_moment(current_user.level+1) - current_user.total_points
    else
      @next_level = SupportedUserLevel.find(current_user.level)
      @points_to_next_level = 0
    end
  end

  def get_task_list
    puts "***  in Get Tasks"
    v_id = @project.id
    @tasks = Task.where("tasks.project_id = :project_id", {:project_id => "#{v_id}"})
    @tasks.order(:phase, :code)
    
    get_totals

    @tasks_hash = {}

    @tasks.each do |t|
      case t.status
        when 'not_started'
          t.image_url = "wizard/pending.png"
        when 'in_progress'
          t.image_url = "wizard/in_progress.png"
        when 'completed'
          t.image_url = "wizard/completed.png"
        else
          t.image_url = "Error"
      end

      dilemma_array(t)

      @tasks_hash[t.phase] ||= {}
      @tasks_hash[t.phase][t.id] ||= []
        @tasks_hash[t.phase][t.id] << t 
      #puts "#{@tasks_hash}"
    end
    @tasks_hash = @tasks_hash.sort_by {|a,b| a }
  end
  
  def dilemma_array(t)
    @dilemma_array = Dilemma.where(task_id: t.id)
    t.dilemma_count = @dilemma_array.count 
    @dilemma_hash = {}
    if @dilemma_array.count > 0 
      @dilemma_array.each do |dilemma|
         @dilemma_id = dilemma.id
         @dilemma_title = dilemma.title
         @dilemma_hash[@dilemma_id] = @dilemma_title
      end
    end
    t.dilemma_list = @dilemma_hash.inspect
  end 

  def get_totals
    @total_duration = @tasks.sum(:duration) 
    @total_cost = @tasks.sum(:cost) 
    @total_paid = @tasks.sum(:paid) 
    @task_count = @tasks.count 
    @complete_task_count = @tasks.where(status: 'completed').count 
    @total_end_date = @project.orig_start_date + @total_duration.days
  end
  
  def set_env
  	if Rails.env = "production"
  	  redirect_to root_url
    end
  end
end