class CreateJobSchedules < ActiveRecord::Migration
  def change
    create_table :job_schedules do |t|
    	t.integer :interval_length
    	t.string :interval_unit
    	t.time 	:run_time

		t.timestamps
    end
  end
end
