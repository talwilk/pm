class GuruRegistrationForm
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :email, :password, :username, :ip_address, :first_name, :last_name, :address, :mobile_number, :mantra, :category_list, :experience, :role

  validate :validate_email_uniqueness
  validate :validate_user
  validates :email, presence: true
  validates :password, presence: true
  validates :category_list, presence: true
  validates_with CategoryListValidator
  validates :experience, presence: true, inclusion: { in: SupportedExperienceTime.all }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mantra, length: { maximum: 500 }
  validates :address, length: { maximum: 50 }
  validates :mobile_number, length: { mimimum:9, maximum: 10 }, format: { with: /0[0-9]{9,10}/ , message: I18n.t("form.invalid_number") }
  # validate :phone_plausible

  def guru_attributes
    {
      email: email,
      password: password,
      signup_way: 'guru',
      username: username,
      registration_ip_address: ip_address,
      role: 'guru'
    }
  end

  def user_profile_attributes
    {
      first_name: first_name,
      last_name: last_name,
      category_list: category_list,
      experience: experience,
      address: address,
      mobile_number: mobile_number,
      mantra: mantra
    }
  end

  private

  def validate_user
    user = User.new(guru_attributes)
    unless user.valid?
      if user.errors[:email].present?
        errors[:email] = user.errors[:email].first
      end

      if user.errors[:password].present?
        errors[:password] = user.errors[:password].first
      end
    end
  end

  def validate_email_uniqueness
    if User.find_by(email: email)
      errors[:email] << _(I18n.t("account_connected_to_this_email_exits"))
    elsif User.only_deleted.find_by(email: email)
      errors[:email] << _(I18n.t("account_connected_to_this_email_deleted"))
    end
  end

  def attributes
    {
      email: nil,
      username: nil,
      password: nil,
      ip_address: nil,
      category_list: nil,
      experience: nil,
      first_name: nil,
      last_name: nil,
      address: nil,
      mobile_number: nil,
      mantra: nil,
      role: nil
    }
  end

  def phone_plausible
    errors.add(:mobile_number, :invalid) if mobile_number.present? && !Phony.plausible?(mobile_number)
  end

end
