class EtlJobImport < ActiveRecord::Migration
  def change
  	change_table "etl_jobs" do |t|
	  	t.text     "query"
	    t.string   "extract_file_file_name"
	    t.string   "extract_file_content_type"
	    t.integer  "extract_file_file_size"
	    t.datetime "extract_file_updated_at"
	    t.integer  "extract_count"
	    t.string   "transform_file_file_name"
	    t.string   "transform_file_content_type"
	    t.integer  "transform_file_file_size"
	    t.datetime "transform_file_updated_at"
	    t.integer  "transform_count"
	    t.string   "load_file_file_name"
	    t.string   "load_file_content_type"
	    t.integer  "load_file_file_size"
	    t.datetime "load_file_updated_at"
	    t.integer  "load_count"
	    t.float    "duration"
	    t.integer  "new_sf_users"
	    t.integer  "errors_count"
	    t.string   "sf_job_id"
	end
  end
end
