class SuperAdmin::GrantPointsController < SuperAdmin::BaseController
  before_action :set_user, only: [:new, :create]

  def new
    @grant_user_points_form = GrantUserPointsForm.new
  end

  def create
    @grant_user_points_form = GrantUserPointsForm.new(user_points_log_params.merge(user: @user))

    if @grant_user_points_form.valid?
      reward = Gamification::SuperAdminReward.new(current_super_admin, @grant_user_points_form)

      if reward.issue_reward
        redirect_to edit_super_admin_user_path(@user), notice: t(:points_granted)
      else
        render :new, notice: t(:something_went_wrong_try_again)
      end
    else
      render :new, notice: t(:something_went_wrong_try_again)
    end
  end

  private

  def user_points_log_params
    params.require(:grant_user_points_form).permit(:points_amount, :super_admin_granted_points_description)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
