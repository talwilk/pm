class DilemmaAdvicesController < ApplicationController
  before_action :authenticate_user!, only: [:favorite, :like]
  before_action :set_dilemma, only: [:create]
  before_action :set_advice, only: [:favorite, :like]

  def create
    if current_user.nil?
      render :js => "window.location = '#{new_user_session_path}'"
    else
      authorize @dilemma, :add_advice?

      service = CreateDilemmaAdviceService.new(@dilemma, dilemma_advice_params)

      if service.call
        @sent = true
        @dilemma_advice = service.dilemma_advice

        reward = Gamification::CreateDilemmaAdviceReward.new(@dilemma_advice)
        reward.issue_reward
        @points_added = reward.points

        respond_to do |format|
          format.js { render :create, layout: false }
        end

      else
        @sent = false
        @dilemma_advice = service.dilemma_advice

        if @dilemma_advice.media.empty?
          @dilemma_advice.media.build
        else
          @existing_media = true
        end

        params.delete (:remotipart_submitted)
        respond_to do |format|
          format.js { render :create, layout: false }
        end
      end
    end
  end

  def like
    authorize @advice, :like?

    if current_user.voted_for? @advice
      @advice.unliked_by current_user #TODO: Add substracting points service
      respond_to do |format|
        format.js { render :like, layout: false }
      end
    else
      @advice.liked_by current_user
      reward = Gamification::LikeDilemmaAdviceReward.new(@advice)
      reward.issue_reward

      respond_to do |format|
        format.js { render :like, layout: false }
      end
    end
  end

  def favorite
    authorize @advice.dilemma, :favorite?
    authorize @advice.dilemma, :country_disabled?

    favorite_advice_selected = @advice.dilemma.favorite_dilemma_advice.present?

    @advice.dilemma.favorite_dilemma_advice_id = @advice.id

    if @advice.dilemma.save
      if !favorite_advice_selected
        reward = Gamification::FavoriteDilemmaAdviceReward.new(@advice)
        reward.issue_reward

        @points_added = reward.points
        flash[:gamification] = t(:points_for_choosing_favourite_dilemma) % { points_added: @points_added }
      end

      redirect_to dilemma_path(@advice.dilemma, anchor: 'favourite-advice')
    else
      redirect_to dilemma_path(@advice.dilemma), alert: t(:favourite_dilemma_cannot_chosen)
    end
  end

  private

  def dilemma_advice_params
    params.require(:dilemma_advice).permit(
      :content,
      :dilemma_id,
      media_attributes: [:id ,:file, :youtube_url, :image_url, :media_description, :file_cache]
    ).merge(user_id: current_user.id)
  end

  def set_dilemma
    @dilemma = Dilemma.find(params[:dilemma_id])
  end

  def set_advice
    @advice = DilemmaAdvice.find(params[:id])
  end
end
