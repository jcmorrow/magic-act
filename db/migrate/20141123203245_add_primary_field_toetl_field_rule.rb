class AddPrimaryFieldToetlFieldRule < ActiveRecord::Migration
  def change
  	add_column :etl_field_rules, :is_primary, :boolean
  end
end
