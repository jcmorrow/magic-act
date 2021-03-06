class ObjectRule < ActiveRecord::Base
	has_many :field_rules
	has_many :job_object_rels
	has_many :jobs, :through => :job_object_rels

	def composeSelect
		select = 'SELECT '
		comma = false
		field_rules.each do |field_rule|
			comma ? select += ', ' : comma = true
			select += field_rule.extract_field + ' as ' + field_rule.load_field
		end
		if(!self.custom_from_clause.nil? && self.custom_from_clause != '')
			select += ' '<<self.custom_from_clause
		else	
			select += ' FROM ' + extract_object
		end
		return select
	end
end