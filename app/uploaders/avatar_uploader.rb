class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :mobile do
    process resize_to_fill: [40, 40]
  end

  version :desktop do
    process resize_to_fill: [40, 40]
  end

  version :edit_profile do
    process resize_to_fill: [115, 115]
  end

  def store_dir
    root_folder = if self._storage == CarrierWave::Storage::AWS
      "#{ENV["AWS_S3_ROOT_FOLDER"]}/"
    else
      'uploads/'
    end

    "#{root_folder}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    [version_name, 'default/default-avatar.png'].compact.join('_')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
