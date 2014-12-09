class CreateJobObjectRels < ActiveRecord::Migration
  def change
    create_table :job_object_rels do |t|
      t.integer :etl_job_id
      t.string :etl_object_rule_id

      t.timestamps
    end
  end
end
