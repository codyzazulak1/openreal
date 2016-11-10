CarrierWave.configure do |config|
	config.fog_credentials = {
		:provider => 'AWS',
		:aws_access_key_id => 	ENV['AWS_ACCESS_KEY_ID'],
		:aws_secret_key => ENV['AWS_SECRET_KEY']

	}
	config.fog_directory = "openreal1"
end