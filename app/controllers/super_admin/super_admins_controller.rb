class SuperAdmin::SuperAdminsController < SuperAdmin::BaseController
  before_action :set_super_admin, only: [:edit, :update, :destroy]

  def index
    @super_admins = SuperAdmin.with_deleted.order(deleted_at: :desc).all
  end

  def new
    @super_admin = SuperAdmin.new
  end

  def edit
  end

  def create
    @super_admin = SuperAdmin.new(super_admin_params)

    if @super_admin.save
      redirect_to super_admin_super_admins_url, notice: _('AlertMessage|Super admin created successfully.')
    else
      render :new
    end
  end

  def update
    if @super_admin.update(update_super_admin_params)
      redirect_to super_admin_super_admins_url, notice: _('AlertMessage|Super admin updated successfully.')
    else
      render :new
    end
  end

  def destroy
    authorize @super_admin

    @super_admin.destroy
    redirect_to super_admin_super_admins_url, notice: _('AlertMessage|Super admin removed successfully.')
  end

  def bring_back
    @super_admin = SuperAdmin.with_deleted.find(params[:id])

    @super_admin.deleted_at = nil
    @super_admin.save!

    redirect_to super_admin_super_admins_url, notice: _('AlertMessage|Super admin was brought back successfully.')
  end

  private

  def set_super_admin
    @super_admin = SuperAdmin.find(params[:id])
  end

  def super_admin_params
    params.require(:super_admin).permit(:email, :full_name, :password, :password_confirmation)
  end

  def update_super_admin_params
    if super_admin_params[:password].blank? && super_admin_params[:password_confirmation].blank?
      super_admin_params.except(:password, :password_confirmation)
    else
      super_admin_params
    end
  end
end
