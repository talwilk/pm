class ValidateUserReopenAccountTokenService
  attr_reader :error

  def initialize(token)
    @token = token
  end

  def call
    if !token_valid?
      @error = _(I18n.t("invalid_token"))
      return false
    elsif !token_not_expired?
      @error = _(I18n.t("token_expired"))
      return false
    else
      return true
    end
  end

  private

  def token_valid?
    User.only_deleted.find_by_reopen_account_token(@token)
  end

  def token_not_expired?
    Time.zone.now < (User.only_deleted.find_by_reopen_account_token(@token).reopen_account_token_sent_at + 3.days)
  end
end
