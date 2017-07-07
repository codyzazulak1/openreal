class PhotouploaderWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0
  def perform(*args)
    # Do something
  end
end
