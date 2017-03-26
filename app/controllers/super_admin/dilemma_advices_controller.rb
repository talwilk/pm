class SuperAdmin::DilemmaAdvicesController < SuperAdmin::BaseController
  before_action :set_dilemma_advice, only: [:edit, :update, :destroy]

  def index
    @dilemma_advices = SuperAdminDilemmaAdviceQuery.new(params).results.page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def edit
  end

  def update
    if @dilemma_advice.update(dilemma_advice_params)
      redirect_to edit_super_admin_dilemma_advice_path(@dilemma_advice), notice: t(:dilemma_advice_saved_successfully)
    else
      render :edit
    end
  end

  def destroy
    @dilemma_advice.destroy

    redirect_to edit_super_admin_dilemma_advice_path(@dilemma_advice), notice: t(:dilemma_advice_has_been_deleted)
  end

  private

  def set_dilemma_advice
    @dilemma_advice = DilemmaAdvice.with_deleted.find(params[:id])
  end

  def dilemma_advice_params
    params.require(:dilemma_advice).permit(:content)
  end
end
