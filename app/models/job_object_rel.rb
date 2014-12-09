class JobObjectRel < ActiveRecord::Base
	belongs_to :etl_job
	belongs_to :etl_object_rule
end
