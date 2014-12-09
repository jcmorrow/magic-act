# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = Admin.new
admin.email = ENV['devise_admin_username']
admin.password = ENV['devise_admin_password']
admin.password_confirmation = ENV['devise_admin_password']
admin.save!



EtlObjectRule.create(:extract_object => "core_user", :load_object => "Akid__c", :is_primary => "true", :active => 'true')
EtlObjectRule.create(:extract_object => "core_order", :load_object => "Opportunity", :is_primary => "false", :active => 'true')

EtlFieldRule.create(:extract_field => "core_user.email", :transformation => "", :load_field => "Email__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_user.first_name", :transformation => "", :load_field => "First_Name__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_user.last_name", :transformation => "", :load_field => "Last_Name__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_user.city", :transformation => "", :load_field => "City__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "if( length( core_user.state ), core_user.state, core_user.region )", :transformation => "", :load_field => "State_Province__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "if( core_user.zip, concat_ws( '-', core_user.zip, if( length( core_user.plus4 ), core_user.plus4, null ) ), core_user.postal )", :transformation => "", :load_field => "Zip_Postal__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_user.country", :transformation => "", :load_field => "Country__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "( select coalesce( group_concat( phone order by core_phone.id desc separator ', ' ), '' ) from core_phone where core_phone.user_id = core_user.id )", :transformation => "", :load_field => "Phone__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_user.subscription_status ", :transformation => "value == \"subscribed\" ? 1 : 0", :load_field => "Is_Subscribed__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "concat_ws( ', ', if( length( core_user.address1 ), core_user.address1, null ), if( length( core_user.address2 ), core_user.address2, null ) )", :transformation => "", :load_field => "Street_Address__c", :etl_object_rule_id => "1", :is_primary => "", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_user.id", :transformation => "", :load_field => "Name", :etl_object_rule_id => "1", :is_primary => "true", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_order.id", :transformation => "", :load_field => "OrderNumber__c", :etl_object_rule_id => "2", :is_primary => "true", :is_foreign_key => "", :active => 'true')
EtlFieldRule.create(:extract_field => "core_order.user_id", :transformation => "", :load_field => "Akid__c", :etl_object_rule_id => "2", :is_primary => "false", :is_foreign_key => "true", :active => 'true')
EtlFieldRule.create(:extract_field => "core_order.import_id", :transformation => "\"Donation Name(TBD)\"", :load_field => "Name", :etl_object_rule_id => "2", :is_primary => "false", :is_foreign_key => "false", :active => 'true')
EtlFieldRule.create(:extract_field => "core_order.id", :transformation => "\"Closed Won\"", :load_field => "StageName", :etl_object_rule_id => "2", :is_primary => "false", :is_foreign_key => "false", :active => 'true')
EtlFieldRule.create(:extract_field => "core_order.created_at", :transformation => "", :load_field => "CloseDate", :etl_object_rule_id => "2", :is_primary => "false", :is_foreign_key => "false", :active => 'true')