class ChangeVarcharToInt < ActiveRecord::Migration
  def change
  	change_column :job_object_rels, :etl_object_rule_id, 'integer USING CAST(etl_object_rule_id AS integer)'
  end
end
