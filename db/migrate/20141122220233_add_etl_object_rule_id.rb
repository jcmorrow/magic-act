class AddEtlObjectRuleId < ActiveRecord::Migration
  def change
  	add_column :etl_field_rules, :etl_object_rule_id, :integer
  end
end
