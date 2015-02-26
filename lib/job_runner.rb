class JobRunner
  include Delayed::RecurringJob
  run_every 1.day
  timezone 'US/Pacific'
  run_at '12:00am'
  queue 'ETL-jobs'
  def perform
    Job.where(is_scheduled: true).each do |job|
    	job.run
    end
  end
end