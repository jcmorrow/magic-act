class AddScheduledBoolToJob < ActiveRecord::Migration
  def change
  	add_column :jobs, :is_scheduled, :boolean
  end
end
