module Gamification
  class BestDilemmaAdviceReward
    attr_reader :points

    def initialize(dilemma_advice)
      @dilemma_advice = dilemma_advice
      @user = @dilemma_advice.user
      @activity = "your_advice_marked_as_favourite"
      @points = SupportedGamificationActivity.find(@activity)
    end

    def issue_reward
      Gamification::UserLevel.add_points(
        user: @user,
        gamificable: @dilemma_advice,
        points: @points,
        activity: @activity
      )

      update_badge_level
    end

    private

    def update_badge_level
      current_points = DilemmaAdvice.where(id: Dilemma.where.not(favorite_dilemma_advice_id: nil).map{ |i| i.favorite_dilemma_advice_id }).where(user_id: @user.id).count
      possible_levels = SupportedBestAdviceBadge.all.values
      current_level = possible_levels.count {|points_needed| current_points >= points_needed}

      if current_level > @user.best_advice_badge
        @user.update_attribute(:best_advice_badge, current_level)
        UserMailer.best_advice_badge(@user).deliver_now
      end
    end
  end
end
