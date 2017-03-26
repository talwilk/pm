module Gamification
  class SuperAdminReward
    attr_reader :points

    def initialize(super_admin, form)
      @super_admin = super_admin
      @form = form
      @user = form.user
      @points = form.points_amount.to_i
      @activity = "super_admin_grant_points"
    end

    def issue_reward
      Gamification::UserLevel.add_points(
        user: @user,
        gamificable: nil,
        points: @points,
        activity: @activity,
        super_admin_id: @super_admin.id,
        super_admin_granted_points_description: @form.super_admin_granted_points_description
      )

      true
    end
  end
end
