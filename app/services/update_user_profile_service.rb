class UpdateUserProfileService
  def initialize(user, form)
    @user = user
    @form = form
  end

  def call
    return false unless @form.valid?

    update_user_profile
  end

  def update_user_profile
    I18n.default_locale = @form.locale
    @user.update_attributes(@form.user_attributes)
    @user.profile.update_attributes(@form.user_profile_attributes)
  end
end
