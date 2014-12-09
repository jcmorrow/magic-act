class ChangeFieldNamesonEtlObjectRules < ActiveRecord::Migration
  def change
  	rename_column :etl_object_rules, :load_field, :load_object
  	rename_column :etl_object_rules, :extract_field, :extract_object
  end
end
