module Page
  module SuperAdmin
    class GuruApplicationsTab < Page::Base
      def visit
        super super_admin_guru_applications_path
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

      def show
        first(:link, "Show").click
      end

      def search
        click_on 'Search'
      end

      def has_started_review_notice?
        page.has_text? 'Application review started'
      end

      def has_rejected_application_notice?
        page.has_text? 'Application rejected'
      end

      def has_accepted_application_notice?
        page.has_text? 'Application accepted'
      end
    end
  end
end
