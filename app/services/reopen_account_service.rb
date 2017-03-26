class ReopenAccountService

  def initialize(token)
    @token = token
  end

  def user
    User.with_deleted.find_by_reopen_account_token(@token)
  end

  def call
    token_validation_service = ValidateUserReopenAccountTokenService.new(@token)

    if token_validation_service.call
      reopen_account
      return true
    else
      return false
    end
  end

  private

  def reopen_account
    user.update_attribute(:reopen_account_token_sent_at, nil)
    user.update_attribute(:reopened_at, Time.zone.now)
    user.update_attribute(:deleted_at, nil)
    user.update_attribute(:reopen_account_token, nil)
  end
end
