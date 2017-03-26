class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  helper :application

  before_action :set_logo

  default from: ENV["DEVISE_MAILER_SENDER"]
  default template_path: "user_mailer"

  def resend_confirmation(user, token)
    @user = user
    @token = token
    mail to: @user.email, subject: I18n.t("emails.user_mailer.resend_confirmation.subject")
  end

  def confirmation_instructions(record, token, opts={})
    mail = super
    mail.subject = set_confirmation_subject
    mail
  end

  def welcome_email(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.welcome_email.subject")
    end
  end

  def first_dilemma_solved(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.first_dilemma_solved.subject")
    end
  end

  def daily_advices(user, dilemma, new_dilemma_advices_count)
    @user = user
    @dilemma = dilemma
    @new_dilemma_advices_count = new_dilemma_advices_count
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.daily_advices.subject")
    end
  end

  def dilemma_closed(user, dilemma)
    @user = user
    @dilemma = dilemma
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.dilemma_closed.subject")
    end
  end

  def favorite_advice_reminder(user, dilemma)
    @user = user
    @dilemma = dilemma
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.favorite_advice_reminder.subject")
    end
  end

  def chosen_as_best_advice(user, dilemma)
    @user = user
    @dilemma = dilemma
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.chosen_as_best_advice.subject")
    end
  end

  def dilemmas_for_advise(user, dilemmas)
    @user = user
    @dilemmas = dilemmas
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.dilemmas_to_advise.subject")
    end
  end

  def missing_user(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.missing_user.subject")
    end
  end

  def missing_guru(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.missing_guru.subject")
    end
  end

  def guru_application_accepted(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.guru_application_accepted.subject")
    end
  end

  def guru_application_rejected(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.guru_application_rejected.subject")
    end
  end

  def new_level(user)
    @user = user
    @level = SupportedUserLevel.find(@user.level)
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.new_level.subject")
    end
  end

  def best_advice_badge(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.best_advice_badge.subject")
    end
  end

  def like_advice_badge(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.like_advice_badge.subject")
    end
  end

  def dilemma_advices_badge(user)
    @user = user
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.dilemma_advices_badge.subject")
    end
  end

  def reopen_account(user)
    @user = user
    @token = @user.reopen_account_token
    I18n.with_locale(@user.profile.locale) do
      mail to: @user.email, subject: I18n.t("emails.user_mailer.reopen_account.subject")
    end
  end

  def guru_invitation(form)
    @email = form.email
    @name = set_name(form)

    mail to: @email, subject: I18n.t("emails.user_mailer.guru_invitation.subject")
  end

  private

  def set_name(form)
    if form.first_name
      name = form.first_name
    elsif form.last_name
      name = " " + form.last_name
    else
      name = form.email
    end
    name
  end

  def set_logo
    attachments["logo"] = {
      data: File.read(Rails.root.join("app/assets/images/logo.png")),
      mime_type: "image/png"
    }
  end

  def set_confirmation_subject
    if @user.role == 'guru'
      if Country.find(@user.country_iso).enabled_at.nil?
        subject = t("emails.user_mailer.guru_confirm_out_of_region.subject")
      else
        subject = t("emails.user_mailer.guru_confirm_with_free_dilemma.subject")
      end
    else
      if Country.find(@user.country_iso).enabled_at.nil?
        subject = t("emails.user_mailer.confirm_out_of_region.subject")
      else
        subject = t("emails.user_mailer.confirm_with_free_dilemma.subject")
      end
    end
    subject
  end

end
