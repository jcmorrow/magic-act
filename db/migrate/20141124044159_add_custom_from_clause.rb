class AddCustomFromClause < ActiveRecord::Migration
  def change
  	add_column :etl_object_rules, :custom_from_clause, :text
  end
end
