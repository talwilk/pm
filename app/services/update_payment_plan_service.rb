class UpdatePaymentPlanService

  def initialize(user, payment_plan)
    @user = user
    @payment_plan = payment_plan
  end

  def call
    User.update(@user.id, payment_plan: @payment_plan) &&
      PaymentPlanTransaction.create(user_id: @user.id, payment_plan: @payment_plan)
  end
end
