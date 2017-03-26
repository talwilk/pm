class SuperAdmin::UsersController < SuperAdmin::BaseController
  before_action :set_user, only: [:edit, :update, :sign_in_as_user]

  def index
    @users = SuperAdminUserQuery.new(params).results.page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def edit
  end

  def update
    @user.skip_reconfirmation!

    if @user.update(user_params)
      redirect_to edit_super_admin_user_path(@user), notice: t(:user_saved_successfully)
    else
      render :edit
    end
  end

  def sign_in_as_user
    sign_in(@user)
    redirect_to root_path, notice: t(:signed_in_successfully)
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to super_admin_users_path, notice: t(:user_removed_successfully)
    else
      redirect_to super_admin_users_path, alert: t(:user_cannot_be_removed)
    end
  end

  private

  def set_user
    @user = User.with_deleted.includes(:profile).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :username, :country_iso, profile_attributes: [:first_name, :last_name, :mobile_number, :company, :mantra])
  end
end
