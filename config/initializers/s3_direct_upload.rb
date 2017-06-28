S3DirectUpload.config do |c|
	c.acces_key_id = ENV['AWS_ACCESS_KEY_ID']
	c.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
	c.bucket = ENV['AWS_BUCKET_NAME']
	c.region = ENV['AWS_REGION']
end