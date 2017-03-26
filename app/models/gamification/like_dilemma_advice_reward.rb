module Gamification
  class LikeDilemmaAdviceReward
    attr_reader :points

    def initialize(dilemma_advice)
      @dilemma_advice = dilemma_advice
      @user = dilemma_advice.user
      @activity = "advice_like"
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
      current_points = @dilemma_advice.votes_for.size
      possible_levels = SupportedLikeAdviceBadge.all.values
      current_level = possible_levels.count {|points_needed| current_points >= points_needed}

      if current_level > @user.like_advice_badge
        @user.update_attribute(:like_advice_badge, current_level)
        UserMailer.like_advice_badge(@user).deliver_now
      end
    end
  end
end
