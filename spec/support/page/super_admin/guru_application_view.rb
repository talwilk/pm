module Page
  module SuperAdmin
    class GuruApplicationView < Page::Base
      form_resource :guru_application

      def initialize(id)
        @id = id
      end

      def visit
        super super_admin_guru_application_path(id: @id)
      end

      def start_review
        click_link 'Start review'
      end

      def reject
        click_link 'Reject'
      end

      def accept
        click_link 'Accept'
      end

      def save_note
        click_button 'Save Comments'
      end

      def go_back
        click_link 'Back'
      end

      def has_started_review_notice?
        page.has_text? 'Application review was started'
      end

      def has_rejected_application_notice?
        page.has_text? 'Application was rejected'
      end

      def has_accepted_application_notice?
        page.has_text? 'Application was accepted'
      end

      def has_being_reviewed_status?
        page.has_text? 'Being reviewed'
      end

      def has_rejected_status?
        page.has_text? 'Rejected'
      end

      def has_accepted_status?
        page.has_text? 'Accepted'
      end
    end
  end
end
