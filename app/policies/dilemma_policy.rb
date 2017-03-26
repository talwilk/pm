class DilemmaPolicy < ApplicationPolicy
  def update?
    user.id == record.user_id && user.confirmed? && !record.ends_at.past?
  end

  def edit?
    user.id == record.user_id && user.confirmed? && !record.ends_at.past?
  end

  def destroy?
    update?
  end

  def new?
    user.confirmed? && (user.first_dilemma_added == false || user.payment_plan.present?)
  end

  def create?
    new?
  end

  def remove_avatar?
    user.id == record.user.id
  end

  def add_advice?
    user.id != record.user_id && !record.ends_at.past?
  end

  def favorite?
    user.id == record.user.id && !record.favorite_advice_ends_at.past?
  end

  def signed_user?
    user != nil
  end

  def country_disabled?
    Country.find(user.country_iso).enabled_at.present?
  end
end
