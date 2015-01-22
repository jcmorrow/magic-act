module Recurring
	class JobScheduler
	  include Delayed::RecurringJob
	  run_every 30.minutes
	  run_at (Time.now + 1.minute).strftime('%l:%M%P')
	  logger.info "job scheduled for "<<(Time.now + 1.minute).strftime('%l:%M%P')
	  #timezone 'US/Pacific'
	  queue 'ETL-jobs'
	  def perform
	  	logger.info "Job should run"
	    EtlJobs.all.each do |job|
	    	job.run
	    	puts "Job should be running"
	    end
	  end
	end
end