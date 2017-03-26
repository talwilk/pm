class CreateDilemmaService
  attr_reader :dilemma

  def initialize(params)
    @params  = params
  end

  def call
    build_dilemma

    ActiveRecord::Base.transaction do
      begin
        build_images
        save_dilemma!
        generate_permalink
        generate_short_url
        set_cover_photo
        set_first_dilemma_added!

        return true
      rescue StandardError => e
        return false
      end
    end
  end

  private

  def build_dilemma
    @dilemma = Dilemma.new(
      @params.merge(
        {
          ends_at: Time.zone.now + 72.hours,
          favorite_advice_ends_at: Time.zone.now + 120.hours
        }
      ))
  end

  def build_images
    @dilemma.media.each do |image|
      image_url = image.image_url
      image.remote_file_url = image_url
    end
  end

  def set_cover_photo
    if @dilemma.media.first.present?
      @dilemma.update_attribute(:cover_photo, @dilemma.media.first.id)

      if !@dilemma.media.first.youtube_url.blank?
        @dilemma.media.each do |image|
          if !image.youtube_url.blank?
            next
          end
          @dilemma.update_attribute(:cover_photo, image.id)
          break
        end
      end
    end

  end

  def save_dilemma!
    @dilemma.save!
  end

  def generate_permalink
    @dilemma.update_attributes(permalink: @dilemma.title.strip.downcase.tr(" ", "-"))
  end

  def generate_short_url
    return if ENV['BITLY_USERNAME'].blank? || ENV['BITLY_API'].blank?

    bitly_client = Bitly.new(ENV['BITLY_USERNAME'], ENV['BITLY_API'])

    begin
      url = Rails.application.routes.url_helpers.dilemma_url(@dilemma, host: ENV['APP_HOST'])
      response = bitly_client.shorten(url)
      @dilemma.update_attributes(short_url: response.short_url)
    rescue BitlyError
    end
  end

  def set_first_dilemma_added!
    if @dilemma.user.first_dilemma_added == false
      @dilemma.user.first_dilemma_added = true
      @dilemma.user.save!
    end
  end
end
