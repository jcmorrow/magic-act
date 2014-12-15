class JobObjectRel < ActiveRecord::Base
	belongs_to :job
	belongs_to :object_rule
end
