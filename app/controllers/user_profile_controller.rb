class UserProfileController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :show, :remove_avatar]
  before_action :set_user, only: [:show, :edit, :update, :remove_avatar]

  def update
    authorize @user.profile
    @form = UpdateUserProfileForm.new(@user, user_profile_attributes, user_profile_form_params)
    service = UpdateUserProfileService.new(@user, @form)

    if service.call
      redirect_to user_path(@user.id), notice: t(:account_updated_successfully)
    else
      render :edit
    end
  end

  def edit
    authorize @user.profile
    @form = UpdateUserProfileForm.new(@user, user_profile_attributes)
  end

  def show

  end

  def remove_avatar
    authorize @user.profile

    if @user.profile.avatar.blank?
      redirect_to edit_profile_path, alert: t(:avatar_not_set)
      return
    end

    @user.profile.remove_avatar!

    if @user.profile.save
      redirect_to edit_profile_path, notice: t(:avatar_removed_successfully)
    else
      redirect_to edit_profile_path, alert: t(:avatar_cannot_be_removed)
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_profile_attributes
    @user.slice('email', 'username').merge(@user.profile.slice(
      'avatar',
      'first_name',
      'last_name',
      'website_link',
      'facebook_link',
      'google_plus_link',
      'twitter_link',
      'pinterest_link',
      'instagram_link',
      'address','company',
      'mobile_number',
      'mantra',
      'show_email',
      'show_mobile_number',
      'category_list',
      'locale'
    ))
  end

  def user_profile_form_params
    params.require(:update_user_profile_form).permit(
      :email,
      :username,
      :avatar,
      :first_name,
      :last_name,
      :website_link,
      :facebook_link,
      :google_plus_link,
      :twitter_link,
      :pinterest_link,
      :instagram_link,
      :address,
      :company,
      :mobile_number,
      :mantra,
      :show_email,
      :show_mobile_number,
      :locale,
      category_list: [],
    )
  end
end
