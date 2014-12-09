class AddSchuduleIDtoJobs < ActiveRecord::Migration
  def change
  	add_column :etl_jobs, :job_schedule_id, :integer
  end
end
