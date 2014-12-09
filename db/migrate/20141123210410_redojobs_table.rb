class RedojobsTable < ActiveRecord::Migration
  def change
  	change_table :etl_jobs do |table|
	  	table.remove :extract_file_file_name, :extract_file_content_type, :extract_file_file_size, :extract_file_updated_at, :transform_file_file_name, :transform_file_content_type, :transform_file_file_size, :transform_file_updated_at, :load_file_file_name, :load_file_content_type, :load_file_file_size, :load_file_updated_at
	  	table.rename :new_sf_users, :new_load_objects
	  	table.rename :sf_job_id, :load_job_id
	end

  	change_table :etl_sub_jobs do |table|
		table.string   :extract_file_file_name
	    table.string   :extract_file_content_type
	    table.integer  :extract_file_file_size
	    table.datetime :extract_file_updated_at
	    table.integer  :extract_count
	    table.string   :transform_file_file_name
	    table.string   :transform_file_content_type
	    table.integer  :transform_file_file_size
	    table.datetime :transform_file_updated_at
	    table.integer  :transform_count
	    table.string   :load_file_file_name
	    table.string   :load_file_content_type
	    table.integer  :load_file_file_size
	    table.datetime :load_file_updated_at
	    table.integer  :load_count
  	end
  end
end