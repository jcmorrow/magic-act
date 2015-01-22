module Recurring
	class JobScheduler
	  include Delayed::RecurringJob
	  run_every 30.minutes
	  run_at (Time.now + 1.minute).strftime('%l:%M%P')
	  logger.info "job scheduled for "<<(Time.now + 1.minute).strftime('%l:%M%P')
	  #timezone 'US/Pacific' #this line is causing some issues on the server.
	  queue 'ETL-jobs'
	  def perform
	  	logger.info "Job should run"
	    Jobs.all.each do |job|
	    	job.run
	    	logger.info "Job is running"
	    end
	  end
	end
end