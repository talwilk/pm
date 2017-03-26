class UpdateDilemmaService
  attr_reader :dilemma

  def initialize(dilemma, params)
    @params  = params
    @dilemma = dilemma
  end

  def call
    if update_dilemma
      true
    else
      false
    end
  end

  private

  def update_dilemma
    @dilemma.update(@params)
    update_permalink
    upload_image_from_url(@dilemma)
    @dilemma.save
  end

  def update_permalink
    @dilemma.update_attributes(permalink: @dilemma.title.strip.downcase.tr(" ", "-"))
  end

  def upload_image_from_url(dilemma)
    dilemma.media.each do |image|
        image_url = image.image_url
        image.remote_file_url = image_url
    end
  end
end
