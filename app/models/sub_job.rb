class SubJob < ActiveRecord::Base
	has_attached_file 	:extract_file,
			            :path => ":attachment/:id/:style.:extension",
			            :storage => :s3,
						:bucket => "actionforce"
	validates_attachment_content_type :extract_file, :content_type => ['text/csv','text/comma-separated-values','text/csv','application/csv','application/excel','application/vnd.ms-excel','application/vnd.msexcel','text/anytext','text/plain']
	has_attached_file   :transform_file,
						:path => ":attachment/:id/:style.:extension",
			            :storage => :s3,
						:bucket => "actionforce"
	validates_attachment_content_type :transform_file, :content_type => ['text/csv','text/comma-separated-values','text/csv','application/csv','application/excel','application/vnd.ms-excel','application/vnd.msexcel','text/anytext','text/plain']
	has_attached_file   :load_file,
						:path => ":attachment/:id/:style.:extension",
			            :storage => :s3,
						:bucket => "actionforce"
	validates_attachment_content_type :load_file, :content_type => ['text/csv','text/comma-separated-values','text/csv','application/csv','application/excel','application/vnd.ms-excel','application/vnd.msexcel','text/anytext','text/plain']

	belongs_to :object_rule
	belongs_to :sub_job_group
	delegate :job, to: :sub_job_group

	def run
		require 'action_kit_api'
		actionKit = ActionKitApi.new
		salesforce = SalesforceBulk::Api.new(ENV['SALESFORCE_USERNAME'], ENV['SALESFORCE_PASSWORD'] + ENV['SALESFORCE_SECURITY_TOKEN'])
		queryResult = runQuery
		self.extract_count = queryResult.count
		#puts queryResult.inspect
		primary_fields = []
		#TEMP EXTRACT, it'd be nice if we could cut down on the verbosity of these functions
		temp_extract_csv = CSV.generate(String.new) do |csv|
			headers = []
			#go through and get the names of the fields to make the CSV clear
			object_rule.field_rules.each do |field_rule|
				headers.push(field_rule.extract_field)
			end
			csv.add_row headers
			queryResult.each do |result_row|
				row = []
				result_row.each_with_index do |field, index|
					row.push(field)
					if(self.object_rule.is_primary && object_rule.field_rules[index].is_primary)
						primary_fields.push(field)
					end
				end
				csv << row
			end
		end
		self.extract_file = StringIO.new(temp_extract_csv)


		#TRANSFORM, it'd be nice if we could cut down on the verbosity of these functions
		load_objects = []
		transformations = []
		temp_transform_csv = CSV.generate(String.new) do |csv|
			object_rule.field_rules.each do |field_rule|
				transformations.push(field_rule.transformation)
			end
			csv.add_row transformations

			queryResult.each do |result|
				values = []
				load_object = {}
				result.each_with_index do |value, index|
					if(transformations[index] == '' || transformations[index].nil?)
						values.push(value)
						load_object[object_rule.field_rules[index].load_field] = value
					else
						values.push(eval(transformations[index]))
						load_object[object_rule.field_rules[index].load_field] = eval(transformations[index])
					end
				end
				csv.add_row(values)
				load_objects.push(load_object)
			end
		end
		self.transform_file = StringIO.new(temp_transform_csv)

		new_objects = 0
		new_object_errors = 0
		load_count = 0
		#puts load_objects.size
		unless(load_objects.empty?)
			temp_load_csv = CSV.generate(String.new) do |csv|
				csv << [ 'ID', 'Success?', 'Created?', 'Error' ] 
				load_objects.in_groups_of(10000, false) do |bulk_upload|
					temp_load_result = salesforce.upsert(object_rule.load_object, bulk_upload, object_rule.field_rules.where(is_primary: true)[0].load_field, true)
					load_count += temp_load_result.result.records.count
					temp_load_result.result.records.each do |row|
						if(row.fields(2)[0] == true)
							new_objects += 1
						end
						if(row.fields(3)[0] != '')
							new_object_errors += 1
						end
						csv << [row.fields(0), row.fields(1), row.fields(2), row.fields(3)]
					end
				end
			end
			self.load_file = StringIO.new(temp_load_csv)
		end
		self.load_count = load_count
		self.errors_count = new_object_errors
		self.new_load_objects = new_objects
		self.save
		if(self.object_rule.is_primary)
			#return a new set of criteria for further subjobs
			#puts primary_fields
			return primary_fields
		end
	end
	def runQuery
		actionKit = ActionKitApi.new
		results = []
		puts composeQuery
		records_left = true
		i = 0
		while(records_left)
			#puts "Querying for the #{i + 1} time."
			query_result = actionKit.query(composeQuery << " OFFSET #{i*1000}")
			results.concat query_result
			i += 1
			if(query_result.length < 1000)
				records_left = false
			end
		end
		return results
	end
	def composeQuery
		temp_query = ''
		#get the select statement
		select = object_rule.composeSelect
		#append it to the temp_query
		temp_query << select
		#grab the where statement of this object
		where = self.query
		if(!where.nil? && where != '')
			#append it if it's not empty
			temp_query << ' ' + where
		end
		temp_query << ' LIMIT 1000'
		#puts temp_query
		return temp_query
	end
end