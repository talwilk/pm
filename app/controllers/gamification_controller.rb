class GamificationController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.level < SupportedUserLevel.last_level
      @points_to_next_level = SupportedUserLevel.upgrade_moment(current_user.level+1) - current_user.total_points if current_user
      @advices_to_next_level = (@points_to_next_level.to_f / SupportedGamificationActivity.find('create_advice')).ceil
    else
      @advices_to_next_level = 0
      @points_to_next_level = 0
    end
  end
end
