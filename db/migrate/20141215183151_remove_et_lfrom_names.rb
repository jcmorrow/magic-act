class RemoveEtLfromNames < ActiveRecord::Migration
  def change
  	rename_table :etl_jobs, :jobs
  	rename_table :etl_sub_jobs, :sub_jobs
  	rename_table :etl_object_rules, :object_rules
  	rename_table :etl_field_rules, :field_rules
  end
end
