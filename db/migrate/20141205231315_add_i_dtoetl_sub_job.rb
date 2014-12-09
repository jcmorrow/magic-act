class AddIDtoetlSubJob < ActiveRecord::Migration
  def change
  	add_column :etl_sub_jobs, :sub_job_group_id, :integer

  end
end
