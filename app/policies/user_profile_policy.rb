class UserProfilePolicy < ApplicationPolicy
  def update?
    user.id == record.user.id
  end

  def edit?
    update?
  end

  def remove_avatar?
    user.id == record.user.id
  end
end

