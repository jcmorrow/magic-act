namespace :schedule do
  desc "TODO"
  task jobs: :environment do
  	require 'job_scheduler'
  	Delayed::Job.where('(handler LIKE ?)', '--- !ruby/object:Recurring::%').destroy_all
  	Recurring::JobScheduler.schedule!
  end

end