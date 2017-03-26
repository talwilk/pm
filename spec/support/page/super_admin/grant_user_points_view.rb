module Page
  module SuperAdmin
    class GrantUserPointsView < Page::Base
      def initialize(id)
        @id = id
      end

      def submit
        click_on 'Grant points'
      end

      def has_blank_field_alert?
        page.has_text? "can't be blank"
      end

      def has_not_a_number_alert?
        page.has_text? 'is not a number'
      end

      def has_invalid_points_amount_alert?
        page.has_text? 'must be greater than 0'
      end
    end
  end
end
