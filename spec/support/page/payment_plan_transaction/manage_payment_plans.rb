module Page
  module PaymentPlanTransaction
    class ManagePaymentPlans < Page::Base
      def visit
        super edit_payment_plan_transaction_path
      end

      def choose_small_plan
        page.find('#small-plan').click
      end

      def choose_medium_plan
        page.find('#medium-plan').click
      end

      def choose_large_plan
        page.find('#large-plan').click
      end

      def has_chosen_plan_notice?
        page.has_css?('.billing-plan__indication')
      end

      def has_successful_chosen_plan_notice?
        page.has_text? 'Congrats! You have been chosen to be a member of the Dilemma Guru Beta community!'
      end

      def has_choose_plan_notice?
        page.has_text? 'Choose your plan'
      end
    end
  end
end
