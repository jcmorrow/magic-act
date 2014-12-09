class AddQueryToSubJob < ActiveRecord::Migration
  def change
  	add_column :etl_sub_jobs, :query, :text
  end
end
