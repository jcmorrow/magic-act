class CreateEtlSubJobs < ActiveRecord::Migration
  def change
    create_table :etl_sub_jobs do |t|
      t.integer :etl_job_id
      t.string :etl_object_rule_id

      t.timestamps
    end
  end
end
