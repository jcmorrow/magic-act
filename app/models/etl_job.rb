class EtlJob < ActiveRecord::Base
	
	has_many :sub_job_groups
	has_many :etl_sub_jobs, through: :sub_job_groups
	has_many :job_object_rels
	has_many :etl_object_rules, through: :job_object_rels
	
	def run
		require 'actionkitapi'
		startTime = Time.now
		p_object_rule = etl_object_rules.where(is_primary: true)[0]
		job_group = SubJobGroup.create(etl_job_id: self.id, status: 'inprogress')
		p_sub_job = EtlSubJob.new(sub_job_group_id: job_group.id, etl_object_rule_id: p_object_rule.id, query: self.query)
		#primary sub jobs return where queries with which to run the rest of the subjobs
		new_where = p_sub_job.run
		#run all non-primaries using the results from the primary. Makes sense to me, we'll see if it holds up
		unless(new_where.empty?)
			etl_object_rules.where(is_primary: false).each do |object_rule|
				EtlSubJob.new(sub_job_group_id: job_group.id, etl_object_rule_id: object_rule.id, query: "WHERE #{object_rule.etl_field_rules.where(is_foreign_key: true)[0].extract_field} IN (#{new_where.join(', ')})").run
			end
		end
	end
	handle_asynchronously :run
end
