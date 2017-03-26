class SuperAdminPolicy < ::ApplicationPolicy
  def destroy?
    user != record
  end
end
