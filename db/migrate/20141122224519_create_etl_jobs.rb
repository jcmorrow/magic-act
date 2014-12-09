class CreateEtlJobs < ActiveRecord::Migration
  def change
    create_table :etl_jobs do |t|

      t.timestamps
    end
  end
end
