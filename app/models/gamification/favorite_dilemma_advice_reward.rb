module Gamification
  class FavoriteDilemmaAdviceReward
    attr_reader :points

    def initialize(dilemma_advice)
      @dilemma_advice = dilemma_advice
      @user = @dilemma_advice.dilemma.user
      @activity = "mark_favourite_advice"
      @points = SupportedGamificationActivity.find(@activity)
    end

    def issue_reward
      Gamification::UserLevel.add_points(
        user: @user,
        gamificable: @dilemma_advice,
        points: @points,
        activity: @activity
      )
    end
  end
end
