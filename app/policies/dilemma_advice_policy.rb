class DilemmaAdvicePolicy < ApplicationPolicy
  def like?
    user.id != record.user_id
  end

  def country_disabled?
    Country.find(user.country_iso).enabled_at.present?
  end
end
