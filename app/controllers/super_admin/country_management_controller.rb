class SuperAdmin::CountryManagementController < SuperAdmin::BaseController
  before_action :set_country, only: [:enable, :disable]

  def index
    @countries = Country.order(enabled_at: :asc).order(:country_iso).all
  end

  def enable
    @country.enabled_at = Time.zone.now
    @country.super_admin_id = current_super_admin.id

    if @country.save
      redirect_to super_admin_country_management_index_path, notice: t(:country_was_enabled)
    else
      redirect_to super_admin_country_management_index_path, notice: t(:country_could_not_be_enabled)
    end
  end

  def disable
    @country.enabled_at = nil
    @country.super_admin_id = nil

    if @country.save
      redirect_to super_admin_country_management_index_path, notice: t(:country_was_disabled)
    else
      redirect_to super_admin_country_management_index_path, notice: t(:country_could_not_be_disabled)
    end
  end

  private

  def set_country
    @country = Country.find_by(country_iso: params[:country_iso])
  end
end
