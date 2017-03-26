class BlogCoverImageUploader < CarrierWave::Uploader::Base

  def store_dir
    if self._storage == CarrierWave::Storage::AWS
      "#{ENV["AWS_S3_ROOT_FOLDER"]}/"
    else
      "uploads/"
    end
  end
end
