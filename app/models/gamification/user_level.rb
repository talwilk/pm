module Gamification
  class UserLevel
    def self.add_points(user:, gamificable:, points:, activity:, super_admin_id: nil, super_admin_granted_points_description: nil)
      user.update_attribute(:total_points, user.total_points + points)

      UserPointsLog.create!(
        user: user,
        gamificable: gamificable,
        points_amount: points,
        activity: activity,
        super_admin_id: super_admin_id,
        super_admin_granted_points_description: super_admin_granted_points_description
      )

      update_user_level(user)
    end

    def self.update_user_level(user)
      new_level = calculate_level(user.total_points)

      if new_level > user.level
        user.update_attribute(:level, new_level)

        unless new_level == 7 && user.signup_way == 'guru'
          UserMailer.new_level(user).deliver_now
        end

        if new_level == 7
          UserToGuruTransitionService.new(user).call
        end
      end
    end

    def self.calculate_level(current_points)
      new_level = 0

      SupportedUserLevel.all.values.each do |level_points|
        break if current_points < level_points

        new_level = SupportedUserLevel.upgrade_level(level_points)
      end

      new_level
    end
  end
end
