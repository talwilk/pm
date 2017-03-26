class SuperAdmin::GuruApplicationsController < SuperAdmin::BaseController
  before_action :set_guru_application, only: [:show,
                                              :start_guru_application_review,
                                              :reject_guru_application,
                                              :accept_guru_application,
                                              :update
                                            ]

  def index
    @guru_applications = GuruApplicationQuery.new(params).results.page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def show
  end

  def update
    if @guru_application.update(guru_application_params)
      redirect_to super_admin_guru_application_path(@guru_application), notice: t(:not_saved_successfully)
    else
      render :show
    end
  end

  def start_guru_application_review
    start_review_service = StartGuruApplicationReviewService.new(@guru_application, current_super_admin)

    if start_review_service.call
      redirect_to super_admin_guru_application_path(@guru_application), notice: t(:application_review_start)
    else
      redirect_to super_admin_guru_applications_path, alert: t(:something_went_wrong)
    end
  end

  def reject_guru_application
    reject_application_service = RejectGuruApplicationService.new(@guru_application, current_super_admin)

    if reject_application_service.call
      redirect_to super_admin_guru_application_path(@guru_application), notice: t(:applcation_rejected)
    else
      redirect_to super_admin_guru_applications_path, alert: t(:something_went_wrong)
    end
  end

  def accept_guru_application
    accept_application_service = AcceptGuruApplicationService.new(@guru_application, current_super_admin)

    if accept_application_service.call
      reward = Gamification::BecomeGuruReward.new(current_super_admin, @guru_application)
      reward.issue_reward

      redirect_to super_admin_guru_application_path(@guru_application), notice: t(:application_accepted)
    else
      redirect_to super_admin_guru_applications_path, alert: t(:something_went_wrong)
    end
  end

  private

  def set_guru_application
    @guru_application = GuruApplication.find(params[:id])
  end

  def guru_application_params
    params.require(:guru_application).permit(:super_admin_note)
  end
end
