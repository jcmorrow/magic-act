class SubJobGroup < ActiveRecord::Base
	has_many :sub_jobs
	belongs_to :job

	def self.errorTotalToday
		errors = 0
		jobs = SubJob.where("created_at >= ?", Time.zone.now.beginning_of_day)
		jobs.each do |job|
			unless(job.errors_count.nil?)
				errors += job.errors_count
			end
		end
		return errors
	end
	def self.errorTotal
		errors = 0
		jobs = SubJob.all
		jobs.each do |job|
			unless(job.errors_count.nil?)
				errors += job.errors_count
			end
		end
		return errors
	end
	def self.etlTotalToday
		etls = 0
		jobs = SubJob.where("created_at >= ?", Time.zone.now.beginning_of_day)
		jobs.each do |job|
			unless(job.load_count.nil?)
				etls += job.load_count
			end
		end
		return etls
	end
	def self.etlTotal
		etls = 0
		jobs = SubJob.all
		jobs.each do |job|
			unless(job.load_count.nil?)
				etls += job.load_count
			end
		end
		return etls
	end
	def self.newTotalToday
		new_records = 0
		jobs = SubJob.where("created_at >= ?", Time.zone.now.beginning_of_day)
		puts jobs.count
		jobs.each do |job|
			unless(job.new_load_objects.nil?)
				new_records += job.new_load_objects
			end
		end
		return new_records
	end
	def self.newTotal
		new_records = 0
		jobs = SubJob.all
		puts jobs.count
		jobs.each do |job|
			unless(job.new_load_objects.nil?)
				new_records += job.new_load_objects
			end
		end
		return new_records
	end
end
