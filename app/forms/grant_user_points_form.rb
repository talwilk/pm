class GrantUserPointsForm
  include ActiveModel::Model

  attr_accessor :points_amount, :super_admin_granted_points_description, :user

  validates :points_amount, presence: true
  validates :points_amount, numericality: { greater_than: 0 }
  validates :super_admin_granted_points_description, presence: true

  def user_points_log_params
    {
      points_amount: points_amount,
      super_admin_granted_points_description: super_admin_granted_points_description,
      user: user
    }
  end
end
