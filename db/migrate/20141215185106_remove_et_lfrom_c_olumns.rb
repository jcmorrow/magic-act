class RemoveEtLfromCOlumns < ActiveRecord::Migration
  def change
  	rename_column :field_rules, :etl_object_rule_id, :object_rule_id
  	rename_column :job_object_rels, :etl_job_id, :job_id
  	rename_column :job_object_rels, :etl_object_rule_id, :object_rule_id
  	rename_column :sub_job_groups, :etl_job_id, :job_id
  	rename_column :sub_jobs, :etl_job_id, :job_id
  	rename_column :sub_jobs, :etl_object_rule_id, :object_rule_id
  end
end
