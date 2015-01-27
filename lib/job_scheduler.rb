class JobScheduler
  include Delayed::RecurringJob
  run_every 1.day
  run_at (Time.now + 1.minute).strftime('%l:%M%P')
  logger.info "job scheduled for "<<(Time.now + 1.minute).strftime('%l:%M%P')
  #timezone 'US/Pacific' #this line is causing some issues on the server.
  queue 'ETL-jobs'
  def perform
    Jobs.where(is_scheduled: true).each do |job|
      logger.info "#{job.id} is scheduled" 
    	job.run
    end
  end
end