class AddPrimaryFieldToetlObjectRule < ActiveRecord::Migration
  def change
  	add_column :etl_object_rules, :is_primary, :boolean
  end
end
