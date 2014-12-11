class AddNamesToJobs < ActiveRecord::Migration
  def change
  	add_column :etl_jobs, :name, :string
  	add_column :etl_object_rules, :name, :string
  	add_column :job_schedules, :name, :string
  end
end
