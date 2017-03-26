class StartGuruApplicationReviewService
  attr_reader :guru_application

  def initialize(guru_application, super_admin)
    @guru_application = guru_application
    @super_admin = super_admin
  end

  def call
    mark_review_as_started
    true
  end

  private

  def mark_review_as_started
    @guru_application.update_attribute(:review_started_at, Time.zone.now)
    @guru_application.update_attribute(:reviewer_id, @super_admin.id)
  end
end
