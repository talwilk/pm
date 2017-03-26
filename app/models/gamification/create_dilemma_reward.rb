module Gamification
  class CreateDilemmaReward
    attr_reader :points

    def initialize(dilemma)
      @dilemma = dilemma
      @user = dilemma.user
      @activity = "create_dilemma"
      @points = SupportedGamificationActivity.find(@activity)
    end

    def issue_reward
      Gamification::UserLevel.add_points(
        user: @user,
        gamificable: @dilemma,
        points: @points,
        activity: @activity
      )
    end
  end
end
