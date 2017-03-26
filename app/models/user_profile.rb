class UserProfile < ActiveRecord::Base
  belongs_to :user, -> { with_deleted }, inverse_of: :profile

  mount_uploader :avatar, AvatarUploader

  acts_as_paranoid
  acts_as_taggable_on :categories
  validates_with CategoryListValidator

  validates :website_link, length: { maximum: 100 }
  validates :company, length: { maximum: 50 }
  
  validates :address, length: { maximum: 50 }
  validates :mantra, length: { maximum: 500 }
  validates :experience, inclusion: { in: SupportedExperienceTime.all }, allow_nil: true
  validates :mobile_number, length: { mimimum:9, maximum: 10 }, format: { with: /0[0-9]{9,10}/ , message: I18n.t("form.invalid_number") }, if: :user_is_guru?
  before_update :smart_add_url_protocol

  def full_name
    if last_name.present?
      "#{first_name} #{last_name}"
    else
      "#{first_name}"
    end
  end

  def mobile_number=(value)
    self[:mobile_number] = Phony.plausible?(value) ? super(Phony.normalize(value)) : super(value)
  end

  private

  def smart_add_url_protocol
    self.facebook_link = SmartUrl.normalize(facebook_link, "https")
    self.twitter_link = SmartUrl.normalize(twitter_link, "https")
    self.pinterest_link = SmartUrl.normalize(pinterest_link, "https")
    self.instagram_link = SmartUrl.normalize(instagram_link, "https")
    self.google_plus_link = SmartUrl.normalize(google_plus_link, "https")
    self.website_link = SmartUrl.normalize(website_link, "http")
  end

  def user_is_guru?
    user.role == 'guru'
  end
end
