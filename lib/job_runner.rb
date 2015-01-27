class JobRunner
  include Delayed::RecurringJob
  run_every 1.day
  #run_at (Time.now + 1.minute).strftime('%l:%M%P')
  run_at '12:00am'
  #logger.info "job scheduled for "<<(Time.now + 1.minute).strftime('%l:%M%P')
  timezone 'US/Pacific' #this line is causing some issues on the server.
  queue 'ETL-jobs'
  def perform
    #puts "PERFORMINGPERFORMINGPERFORMINGPERFORMINGPERFORMINGPERFORMINGPERFORMING"
    Job.where(is_scheduled: true).each do |job|
      #puts "hey look, we're running a job!"
    	job.run
    end
  end
end