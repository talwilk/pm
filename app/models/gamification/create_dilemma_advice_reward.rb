module Gamification
  class CreateDilemmaAdviceReward
    attr_reader :points

    def initialize(dilemma_advice)
      @dilemma_advice = dilemma_advice
      @user = dilemma_advice.user
      @activity = dilemma_advice.media.count > 0 ? "create_advice_with_media" : "create_advice"
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
      current_points = @dilemma_advice.dilemma.advices.count
      possible_levels = SupportedDilemmaAdvicesBadge.all.values
      current_level = possible_levels.count {|points_needed| current_points >= points_needed}

      if current_level > @dilemma_advice.dilemma.user.dilemma_advices_badge
        @dilemma_advice.dilemma.user.update_attribute(:dilemma_advices_badge, current_level)
        UserMailer.dilemma_advices_badge(@dilemma_advice.dilemma.user).deliver_now
      end
    end
  end
end
