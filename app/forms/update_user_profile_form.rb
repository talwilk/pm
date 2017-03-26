class UpdateUserProfileForm
  include ActiveModel::Model

  attr_accessor(
    :email,
    :avatar,
    :username,
    :first_name,
    :last_name,
    :category_list,
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
    :locale
  )

  validates :email, presence: true
  validates :username, presence: true
  validates :first_name, presence: true, if: :user_is_guru?
  validates_with CategoryListValidator
  validates :last_name, presence: true, if: :user_is_guru?
  validates :website_link, length: { maximum: 100 }, allow_blank: true, format: { with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, message: I18n.t("form.website_link"), :multiline => true  }
  validates :facebook_link, length: { maximum: 100 }, allow_blank: true, format: { with: /(?:http:\/\/)?(?:www\.)?facebook\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*([\w\-]*)/, message: I18n.t("form.facebook_link") }
  validates :instagram_link, length: { maximum: 100 }, allow_blank: true, format: { with: /(?:(?:http|https):\/\/)?(?:www.)?(?:instagram.com|instagr.am)\/([A-Za-z0-9\-_]+)/i, message: I18n.t("form.instagram_link"), :multiline => true }
  validates :twitter_link, length: { maximum: 100 }, allow_blank: true, format: { with: /(?:http:\/\/)?(?:www\.)?twitter\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*([\w\-]*)/, message: I18n.t("form.twitter_link") }
  validates :pinterest_link, length: { maximum: 100 }, allow_blank: true, format: { with: /(?:(?:http|https):\/\/)?(?:www\.|(^[a-z]{2})\.)?(?:pinterest\.com)\/([A-Za-z0-9\-_]+)/i, message: I18n.t("form.pinterest_link") }
  validates :google_plus_link, length: { maximum: 100 }, allow_blank: true, format: { with: /plus\.google\.com\/.?\/?.?\/?([0-9]*)/i, message: I18n.t("form.google_link") }
  # validate :phone_plausible
  validates :mobile_number, length: { mimimum:9, maximum: 10 }, format: { with: /0[0-9]{9,10}/ , message: I18n.t("form.invalid_number") }, if: :user_is_guru?
  validates :locale, presence: true

  def initialize(user, user_profile_attr, attributes = {})
    user_profile_attr = user_profile_attr.except("avatar") if attributes.include?("avatar") == false
    super user_profile_attr.merge(attributes)
    @user = user
  end

  def user_profile_attributes
    {
      avatar: avatar,
      first_name: first_name,
      last_name: last_name,
      category_list: category_list,
      website_link: website_link,
      facebook_link: facebook_link,
      google_plus_link: google_plus_link,
      twitter_link: twitter_link,
      pinterest_link: pinterest_link,
      instagram_link: instagram_link,
      address: address,
      company: company,
      mobile_number: mobile_number,
      mantra: mantra,
      show_mobile_number: show_mobile_number,
      show_email: show_email,
      locale: locale
    }
  end

  def user_attributes
    {
      email: email,
      username: username
    }
  end

  private

  def user_is_guru?
    @user.role == 'guru'
  end

  def phone_plausible
    errors.add(:mobile_number, :invalid) if mobile_number.present? && !Phony.plausible?(mobile_number)
  end
end
