class AddForeignKeyToEtlFields < ActiveRecord::Migration
  def change
  	add_column :etl_field_rules, :is_foreign_key, :boolean
  end
end
