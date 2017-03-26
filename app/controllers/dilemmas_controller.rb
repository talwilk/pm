class DilemmasController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :new, :create, :destroy, :remove_media]
  before_action :set_dilemma, only: [:show, :edit, :update, :destroy]
  before_action :disable_dilemma, only: [:edit, :update, :destroy]
  before_action :set_user_dilemmas, only: [:show]
  before_action :set_category_dilemmas, only: [:show]
  before_action :set_medium, only: [:remove_media, :set_cover_photo]
  before_action :check_payment, only: [:new]

  def index
    if !params.has_key?(:sort_by)
      params[:sort_by] = "newest"
    end

    @dilemma_query = DilemmaQuery.new(params)
    @dilemmas = @dilemma_query.results
    @gurus = FeaturedGuruQuery.new.results
    @trending_dilemmas = TrendingDilemmaQuery.new(Dilemma.all).results

    if current_user.nil?
      guest_user = User.new
      guest_user.country_iso = session[:country_iso]
      @dilemmas = DilemmaPolicy::Scope.new(guest_user, @dilemmas).resolve.page(params[:page]).per(DEFAULT_PER_PAGE)
      @trending_dilemmas = DilemmaPolicy::Scope.new(guest_user, @trending_dilemmas).resolve.first(2)
    else
      @dilemmas = @dilemmas.page(params[:page]).per(DEFAULT_PER_PAGE)
      @trending_dilemmas = @trending_dilemmas.first(2)
    end

    if params[:load_more]
      @load_more = true
    end

    respond_to do |format|
      format.html
      format.js { render 'index', layout: false }
    end
  end

  def new
    authorize Dilemma
    authorize Dilemma, :country_disabled?

    @dilemma = Dilemma.new
    @dilemma.media.build

    @task_id = params[:task_id] 
    if !@task_id.nil?
      set_task
    end

    if !@current_task.nil?
      @dilemma.task_id = @current_task.id
    end

    @sample_dilemmas = Dilemma.order("RANDOM()").first(3)
  end

  def create
    authorize Dilemma
    authorize Dilemma, :country_disabled?

    service = CreateDilemmaService.new(dilemma_params)
    
    if service.call
      reward = Gamification::CreateDilemmaReward.new(service.dilemma)
      reward.issue_reward
      @points_added = reward.points
      flash[:gamification] = t(:points_got_for_posting_dilemma) % {points_added: @points_added}    
      
      @dilemma = service.dilemma
      if @dilemma.task_id.nil? 
        redirect_to dilemma_path(service.dilemma)
      else
        puts "**** task ID #{@dilemma.task_id}"
        @task = Task.find(@dilemma.task_id)
        puts "**** project ID #{@task.project_id}"
        @project = Task.find(@task.project_id)
        redirect_to root_path
      end

    else
      
      if @dilemma.media.empty?
        @dilemma.media.build
      else
        @existing_media = true
      end
      render :new
    end
  end

  def show
    @dilemma_guru_advices = DilemmaAdvice.where(dilemma_id: @dilemma.id).where.not(id: @dilemma.favorite_dilemma_advice_id).includes(:user).where(users: { role: 'guru' }).all.order(cached_votes_up: :desc)
    @dilemma_user_advices = DilemmaAdvice.where(dilemma_id: @dilemma.id).where.not(id: @dilemma.favorite_dilemma_advice_id).includes(:user).where(users: { role: 'regular' }).all.order(cached_votes_up: :desc)
    @dilemma_advice = @dilemma.advices.build
    @dilemma_advice.media.build

    @favorite_advice = @dilemma.favorite_dilemma_advice
    @dilemma_radar = Dilemma.order("(select count(*) from dilemma_advices where dilemma_id=dilemmas.id) desc").first
  end

  def update
    authorize @dilemma
    authorize @dilemma, :country_disabled?

    service = UpdateDilemmaService.new(@dilemma, dilemma_params)

    if service.call
      redirect_to dilemma_path(service.dilemma), notice: t(:dilemma_successfully_updated)
    else
      @dilemma = service.dilemma
      if !@dilemma.media.exists?
        @dilemma.media.build
      end
      render :edit
    end
  end

  def edit
    authorize @dilemma
    authorize @dilemma, :country_disabled?

    if !@dilemma.media.exists?
      @dilemma.media.build
    end
  end

  def set_cover_photo
    @media.mediable.cover_photo = @media.id
     if @media.mediable.save
       redirect_to edit_dilemma_path(@media.mediable_id), notice: t(:cover_photo_successfully_updated)
     else
       redirect_to edit_dilemma_path(@media.mediable_id), notice: t(:cover_photo_cannot_updated)
     end
  end

  def destroy
    authorize @dilemma
    authorize @dilemma, :country_disabled?


    @dilemma.destroy #TODO: Add substracting points service
    redirect_to root_path, notice: t(:dilemma_has_been_deleted)
  end

  def remove_media
    authorize @media.mediable, :country_disabled?

    media_count = Medium.where(mediable_id: @media.mediable_id).count
    if media_count < 2
      redirect_to edit_dilemma_path(@media.mediable_id), alert: t(:dilemma_have_one_media)
    else
      mediable_id = @media.mediable_id
      if @media.file.present?
        @media.remove_file!
      end
      if @media.destroy
        redirect_to edit_dilemma_path(mediable_id), notice: t(:media_removed_successfully)
      else
        redirect_to edit_dilemma_path(mediable_id), alert: t(:media_cannot_be_removed)
      end
    end
  end

  private

  def dilemma_params
      params.require(:dilemma).permit(
        :title,
        :description,
        {category_list: []},
        :cover_photo,
        :task_id,
        media_attributes: [:id ,:file, :youtube_url, :image_url, :media_description, :file_cache]).merge(user_id: current_user.id)
  end

  def set_dilemma
    @dilemma = Dilemma.find(params[:id])
  end

  def set_medium
    @media = Medium.find(params[:id])
  end

  def set_user_dilemmas
    @user_dilemmas = Dilemma.where(user_id: @dilemma.user_id).where.not(id: @dilemma.id).limit(5).order(created_at: :desc)
  end

  def set_task
    puts "*** in set_task"
    @current_task = Task.find(params[:task_id])
  end

  def set_category_dilemmas
    categories = @dilemma.category_list
    @same_category_dilemmas = Dilemma.tagged_with(categories, :any => true).limit(3).where.not(id: @dilemma.id)
    if current_user.present?
      @same_category_dilemmas = policy_scope(@same_category_dilemmas)
    end
  end

  def disable_dilemma
    if !@dilemma.first_advice_added?
      true
    else
      redirect_to dilemma_path, alert: t(:dilemma_already_commented)
    end
  end

  def check_payment
    if current_user.payment_plan.blank? && current_user.first_dilemma_added == true
      flash[:payment] = _('AlertMessage|render_payment_modal')
      redirect_to edit_payment_plan_transaction_path
    end
  end
end
