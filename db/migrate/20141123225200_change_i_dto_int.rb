class ChangeIDtoInt < ActiveRecord::Migration
  def change
  	change_column :etl_sub_jobs, :etl_object_rule_id, 'integer USING CAST(etl_object_rule_id AS integer)'
  end
end
