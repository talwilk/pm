class SuperAdmin::DilemmasController < SuperAdmin::BaseController
  before_action :set_dilemma, only: [:edit, :update, :destroy]

  def index
    @dilemmas = SuperAdminDilemmaQuery.new(params).results.page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def edit
  end

  def update
    if @dilemma.update(dilemma_params)
      redirect_to edit_super_admin_dilemma_path(@dilemma), notice: t(:dilemma_saved_successfully)
    else
      render :edit
    end
  end

  def destroy
    @dilemma.destroy

    redirect_to super_admin_dilemmas_path, notice: t(:dilemma_has_been_destroyed)
  end

  private

  def set_dilemma
    @dilemma = Dilemma.with_deleted.find(params[:id])
  end

  def dilemma_params
    params.require(:dilemma).permit(:title, :description)
  end
end
