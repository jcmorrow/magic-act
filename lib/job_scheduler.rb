module Recurring
	class JobScheduler
	  include Delayed::RecurringJob
	  run_every 1.day
	  run_at (Time.now + 1.minute).strftime('%l:%M%P')
	  timezone 'US/Pacific'
	  queue 'ETL-jobs'
	  def perform
	    EtlJobs.all.each do |job|
	    	job.run
	    end
	  end
	end
end