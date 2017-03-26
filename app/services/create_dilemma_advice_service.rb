class CreateDilemmaAdviceService
  attr_reader :dilemma_advice

  def initialize(dilemma, params)
    @dilemma = dilemma
    @params  = params
  end

  def call
    build_dilemma_advice

    ActiveRecord::Base.transaction do
      begin
        build_images
        save_dilemma_advice!

        return true
      rescue Exception => e
        return false
      end
    end
  end

  private

  def build_dilemma_advice
    @dilemma_advice = @dilemma.advices.build(@params)
  end

  def build_images
    @dilemma_advice.media.each do |image|
      image_url = image.image_url
      image.remote_file_url = image_url
    end
  end

  def save_dilemma_advice!
    @dilemma_advice.save!
  end
end
