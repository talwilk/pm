class SuperAdmin::MediaController < SuperAdmin::BaseController
  before_action :set_medium, only: [:destroy]

  def destroy
    media_count = Medium.where(mediable_id: @media.mediable_id).count
    mediable_type = @media.mediable.class.to_s

    redirect_path = case mediable_type
      when 'Dilemma'
        edit_super_admin_dilemma_path(@media.mediable)
      when 'DilemmaAdvice'
        edit_super_admin_dilemma_advice_path(@media.mediable)
    end

    if mediable_type.eql?('Dilemma') && media_count < 2
      redirect_to redirect_path, alert: t(:dilemma_need_to_have_one_media)
    else
      if @media.file.present?
        @media.remove_file!
      end

      if @media.destroy
        redirect_to redirect_path, notice: t(:media_removed_successfully)
      else
        redirect_to redirect_path, alert: t(:media_cannot_be_removed)
      end
    end
  end

  private

  def set_medium
    @media = Medium.find(params[:id])
  end
end
