class SendReopenAccountTokenService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    update_reopen_account_token
    send_reopen_account_token
    return true
  end

  private

  def update_reopen_account_token
    @token = Devise.friendly_token

    loop do
      break unless User.with_deleted.find_by(reopen_account_token: @token)

      @token = Devise.friendly_token
    end

    @user.update_attribute(:reopen_account_token, @token)
    @user.update_attribute(:reopen_account_token_sent_at, Time.zone.now)
  end

  def send_reopen_account_token
    UserMailer.reopen_account(@user).deliver_now
  end
end
