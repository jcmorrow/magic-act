class CreateSubJobGroups < ActiveRecord::Migration
  def change
    create_table :sub_job_groups do |t|

   	  t.integer :etl_job_id
   	  t.string :status

      t.timestamps
    end
  end
end
