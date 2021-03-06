CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
  elsif Rails.env.development? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: "ap-northeast-1"
    }
    config.fog_directory = ENV["S3_BUCKET"]
    config.asset_host = ENV["ASSET_HOST"]
  end
end
