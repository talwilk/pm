CarrierWave.configure do |config|

  if ENV["AWS_S3_ROOT_FOLDER"].nil? || ENV["AWS_S3_ROOT_FOLDER"].blank?
    config.storage    = :file
  else
    config.storage    = :aws
    config.aws_bucket = ENV["AWS_S3_BUCKET"]
    config.aws_acl    = 'public-read'
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7
    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }
    config.aws_credentials = {
      access_key_id:    ENV["AWS_S3_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_S3_SECRET_ACCESS_KEY"],
      region:            ENV["AWS_S3_REGION"]
    }
  end
end

