class Switchfieldbetweenjobandsubjob < ActiveRecord::Migration
  def change
  	change_table :etl_jobs do |table|
  		table.remove "load_job_id"
  	end
  	change_table :etl_sub_jobs do |table|
  		table.integer  "new_load_objects"
	    table.integer  "errors_count"
	    table.string   "load_job_id"
	    table.float    "duration"
  	end
  end
end
