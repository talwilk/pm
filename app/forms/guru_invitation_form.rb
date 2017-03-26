class GuruInvitationForm
  include ActiveModel::Model

  attr_accessor :email, :username, :first_name, :last_name

  validates :email, presence: true
  validate :validate_user
  validate :email_uniqueness

  private

  def validate_user
    user = User.new(email: email)
    unless user.valid?
      if user.errors[:email].present?
        errors[:email] = user.errors[:email].first
      end
    end
  end

  def email_uniqueness
    if User.where(role: 'guru').find_by(email: email)
      errors[:email] << _(I18n.t("is_already_a_guru"))
    elsif User.only_deleted.where(role: 'guru').find_by(email: email)
      errors[:email] << _(I18n.t("was_a_guru"))
    end
  end
end
