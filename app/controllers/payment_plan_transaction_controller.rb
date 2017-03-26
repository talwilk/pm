class PaymentPlanTransactionController < ApplicationController
  before_action :authenticate_user!

  def edit
    @payment_plans = PaymentPlanTransaction.where(user_id: current_user.id)

    if current_user.payment_plan.present?
      @current_plan = PaymentPlanTransaction.find_by(user_id: current_user.id)
    end
  end

  def update
    if current_user.payment_plan.blank? || current_user.payment_plan == 'true'
      service = UpdatePaymentPlanService.new(current_user, params[:payment_plan])

      if service.call
        flash[:free_user] = _('AlertMessage|render_free_user_modal')
        redirect_to edit_payment_plan_transaction_path
      else
        redirect_to edit_payment_plan_transaction_path, notice: t(:unable_to_choose_your_plan)
      end
    else
      redirect_to edit_payment_plan_transaction_path, alert: t(:already_chosen_your_plan)
    end
  end
end
