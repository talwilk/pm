class MediaUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :desktop do
    process resize_default: [781, 500]
  end

  version :mobile do
    process resize_default: [714, 300]
  end

  version :desktop_cover_thumbnail do
    process resize_thumbnail: [305, 180]
  end

  version :mobile_cover_thumbnail do
    process resize_thumbnail: [714, 360]
  end

  version :desktop_advice_thumbnail do
    process resize_thumbnail: [240, 160]
  end

  version :mobile_advice_thumbnail do
    process resize_thumbnail: [714, 360]
  end

  def store_dir
    root_folder = if self._storage == CarrierWave::Storage::AWS
      "#{ENV["AWS_S3_ROOT_FOLDER"]}/"
    else
      'uploads/'
    end

    "#{root_folder}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  protected

  def resize_default(width, height)
    manipulate! do |img|
      if img.height <= img.width
      img.combine_options do |cmd|
        cmd.resize "#{width}x#{nil}"
      end
      elsif img.height > img.width
        img.combine_options do |cmd|
          cmd.resize "#{nil}x#{height}"
        end
      end
      img = yield(img) if block_given?
      img
    end
  end

  def resize_thumbnail(width, height)
    manipulate! do |img|
      img.combine_options do |cmd|
        cmd.resize "#{width}x#{nil}"
      end
      img.combine_options do |cmd|
        x = (img.width - width)/2
        y = (img.height - height)/2
        cmd.crop("#{width}x#{height}+#{x}+#{y}")
      end
      if img.height < height
        img.combine_options do |cmd|
          cmd.resize "#{width}x#{height}!"
        end
      end
      img = yield(img) if block_given?
      img
    end
  end
end
