module Gamification
  class BecomeGuruReward
    attr_reader :points

    def initialize(super_admin, guru_application)
      @super_admin = super_admin
      @guru_application = guru_application
      @user = guru_application.user
      @activity = "register_as_guru"
      @points = SupportedGamificationActivity.find(@activity)
    end

    def issue_reward
      Gamification::UserLevel.add_points(
        user: @user,
        gamificable: @guru_application,
        points: @points,
        activity: @activity,
        super_admin_id: @super_admin.id
      )
    end
  end
end
