class PaymentPlanTransaction < ActiveRecord::Base
  belongs_to :user

  acts_as_paranoid
  validates :payment_plan, inclusion: { in: SupportedPaymentPlan.all }
end
