class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "TestJob is running with arguments: #{args.inspect}"
    sleep 2
    Rails.logger.info "TestJob has finished."
  end
end
